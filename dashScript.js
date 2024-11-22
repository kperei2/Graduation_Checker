const addSemesterButton = document.getElementById('addSemesterButton');
const semesterPopup = document.getElementById('semesterPopup');
const searchPopup = document.getElementById('searchPopup');
const semestersContainer = document.getElementById('semestersContainer');
const searchInput = document.getElementById('searchInput');
const searchResults = document.getElementById('searchResults');
const creditCounter = document.querySelector('.counter');
let currentSemesterTable = null;
const categoryFilter = document.getElementById('categoryFilter');

addSemesterButton.addEventListener('click', function() {
    addSemesterButton.style.display = 'none';
    semesterPopup.style.display = 'block';
});

function createSemester() {
    const semesterName = document.getElementById('semesterName').value;
    if (!semesterName) return;

    // Create new semester using the container-based approach
    const tableContainer = createSemesterTable(semesterName);
    semestersContainer.appendChild(tableContainer);
    
    // Set the current semester table to the new container
    currentSemesterTable = tableContainer;
    
    // Hide/show popups
    semesterPopup.style.display = 'none';
    searchPopup.style.display = 'block';
    document.getElementById('semesterName').value = '';
}

function closeSearchPopup() {
    searchPopup.style.display = 'none';
    addSemesterButton.style.display = 'flex';
    searchInput.value = '';
    searchResults.innerHTML = '';
}

function updateTotalCredits() {
    let totalCredits = 0;
    const tables = document.getElementsByClassName('semester-table');
    
    Array.from(tables).forEach(table => {
        let semesterCredits = 0;
        // Skip the header row, start from index 1
        for (let i = 1; i < table.rows.length; i++) {
            const creditsText = table.rows[i].cells[1].textContent;
            const credits = parseInt(creditsText);
            semesterCredits += credits;
            totalCredits += credits;
        }
        
        // Update semester credits counter
        const creditsCounter = table.parentElement.querySelector('.semester-credits span');
        creditsCounter.textContent = `Total Credits: ${semesterCredits}`;
    });
    
    // Update the main credit counter
    creditCounter.textContent = `${totalCredits} / 128`;

    // Update progress bar
    const progressFill = document.querySelector('.progress-fill');
    const percentage = (totalCredits / 128) * 100;
    progressFill.style.width = `${Math.min(percentage, 100)}%`;
}

function addCourseToSemester(code, name, credits) {
    if (!currentSemesterTable) return;
    
    // Check if adding this course would exceed the credit limit
    const table = currentSemesterTable.querySelector('.semester-table');
    const currentCredits = Array.from(table.rows)
        .slice(1) // Skip header row
        .reduce((sum, row) => sum + parseInt(row.cells[1].textContent), 0);
    
    if (currentCredits + credits > 23) {
        // Close search popup
        closeSearchPopup();
        // Show warning popup
        showWarningPopup();
        return;
    }
    
    const row = document.createElement('tr');
    row.innerHTML = `
        <td>
            <div class="course-cell">
                <span class="course-code">${code}</span>
                <span class="course-name">${name}</span>
            </div>
        </td>
        <td class="course-credits">${credits}</td>
        <td><button class="delete-course-btn" onclick="removeCourse(this)">×</button></td>
    `;
    
    table.appendChild(row);
    updateTotalCredits();
}

function removeCourse(button) {
    const row = button.closest('tr');
    row.remove();
    updateTotalCredits();
    
    // Refresh search results if search popup is open
    if (searchPopup.style.display === 'block') {
        const searchTerm = searchInput.value.trim();
        const selectedCategory = categoryFilter.value;
        if (searchTerm.length >= 2 || selectedCategory !== 'all') {
            searchCourses(searchTerm, selectedCategory);
        }
    }
}

// search funtionality
searchInput.addEventListener('input', function() {
    performSearch();
});

categoryFilter.addEventListener('change', function() {
    performSearch();
});

function performSearch() {
    const searchTerm = searchInput.value.trim();
    const selectedCategory = categoryFilter.value;
    
    if (searchTerm.length >= 2 || selectedCategory !== 'all') {
        searchCourses(searchTerm, selectedCategory);
    } else {
        searchResults.innerHTML = '';
    }
}

async function searchCourses(searchTerm, category) {
    try {
        const response = await fetch(`http://localhost:3000/api/search-courses?term=${searchTerm}`);
        const courses = await response.json();
        
        // Filter courses by category if a specific category is selected
        let filteredCourses = courses;
        if (category !== 'all') {
            filteredCourses = courses.filter(course => course.category === category);
        }
        
        // Filter out existing courses
        filteredCourses = filterOutExistingCourses(filteredCourses);
        
        displaySearchResults(filteredCourses);
    } catch (error) {
        console.error('Error searching courses:', error);
        searchResults.innerHTML = '<div class="search-item">Error searching courses</div>';
    }
}

function filterOutExistingCourses(courses) {
    // Get all course codes from all semesters
    const existingCodes = new Set();
    const allTables = document.querySelectorAll('.semester-table');
    
    allTables.forEach(table => {
        const tableCells = table.querySelectorAll('.course-code');
        tableCells.forEach(cell => {
            existingCodes.add(cell.textContent.trim());
        });
    });
    
    // Filter out courses that are already in any semester
    return courses.filter(course => !existingCodes.has(course.course_code));
}

function displaySearchResults(courses) {
    const searchResults = document.getElementById('searchResults');
    searchResults.innerHTML = '';
    
    const table = document.createElement('table');
    table.className = 'search-table';
    
    // Create header row
    const headerRow = document.createElement('tr');
    headerRow.innerHTML = `
        <td>
            <div class="course-header">
                <span class="header-code">Course</span>
                <span class="header-name">Course Name</span>
            </div>
        </td>
        <td class="credits-header">Credits</td>
        <td></td>
    `;
    table.appendChild(headerRow);

    // Create course rows
    courses.forEach(course => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>
                <div class="course-cell">
                    <span class="course-code">${course.course_code}</span>
                    <span class="course-name">${course.course_name}</span>
                </div>
            </td>
            <td class="course-credits">${course.credits}</td>
            <td class="button-cell">
                <button class="circle-button" onclick="handleSearchResult('${course.course_code}', '${course.course_name}', ${course.credits})">+</button>
            </td>
        `;
        table.appendChild(row);
    });
    
    searchResults.appendChild(table);
}

function createSemesterTable(semesterName) {
    const container = document.createElement('div');
    container.className = 'semester-container';

    // Create semester header with name and buttons
    const header = document.createElement('div');
    header.className = 'semester-header';
    
    const nameSpan = document.createElement('span');
    nameSpan.textContent = semesterName;
    
    const buttonContainer = document.createElement('div');
    buttonContainer.className = 'semester-buttons';
    
    const searchButton = document.createElement('button');
    searchButton.className = 'search-classes-btn';
    searchButton.innerHTML = `
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" 
                fill="currentColor"/>
        </svg>
    `;
    searchButton.onclick = () => showSearchPopup(container);
    
    const deleteButton = document.createElement('button');
    deleteButton.textContent = '×';
    deleteButton.className = 'delete-semester-btn';
    deleteButton.onclick = () => {
        container.remove();
        updateTotalCredits();
    };
    
    buttonContainer.appendChild(searchButton);
    buttonContainer.appendChild(deleteButton);
    header.appendChild(nameSpan);
    header.appendChild(buttonContainer);
    
    // Create the table
    const table = document.createElement('table');
    table.className = 'semester-table';
    
    // Create header row
    const headerRow = document.createElement('tr');
    
    // Course column with code and name
    const courseHeader = document.createElement('td');
    courseHeader.className = 'header-cell';
    courseHeader.innerHTML = `
        <div class="course-header">
            <span class="header-code">Course</span>
            <span class="header-name">Course Name</span>
        </div>
    `;
    
    // Credits header
    const creditsHeader = document.createElement('td');
    creditsHeader.innerHTML = '<span>Credits</span>';
    creditsHeader.className = 'credits-header';
    
    // Empty header for delete button column
    const deleteHeader = document.createElement('td');
    deleteHeader.textContent = '';
    
    headerRow.appendChild(courseHeader);
    headerRow.appendChild(creditsHeader);
    headerRow.appendChild(deleteHeader);
    
    table.appendChild(headerRow);
    
    container.appendChild(header);
    container.appendChild(table);
    
    // Add semester credits counter
    const creditsCounter = document.createElement('div');
    creditsCounter.className = 'semester-credits';
    creditsCounter.innerHTML = '<span>Total Credits: 0</span>';
    container.appendChild(creditsCounter);
    
    return container;
}

function showSearchPopup(semesterContainer) {
    currentSemesterTable = semesterContainer;
    const searchPopup = document.getElementById('searchPopup');
    searchPopup.style.display = 'block';
    
    // Reset filters and search
    const searchInput = document.getElementById('searchInput');
    categoryFilter.value = 'all';  // Reset category filter
    searchInput.value = '';
    searchInput.focus();
    document.getElementById('searchResults').innerHTML = '';
}

function handleSearchResult(code, name, credits) {
    // Add the course to the semester
    addCourseToSemester(code, name, credits);
    
    // Get the current search term and category
    const searchTerm = searchInput.value.trim();
    const selectedCategory = categoryFilter.value;
    
    // Refresh search results maintaining both search term and category
    if (searchTerm.length >= 2 || selectedCategory !== 'all') {
        searchCourses(searchTerm, selectedCategory);
    }
}

// Make sure the Done button calls closeSearchPopup
document.querySelector('.done-button').addEventListener('click', closeSearchPopup);

// Add these new functions
function showWarningPopup() {
    document.getElementById('warningPopup').style.display = 'block';
}

function closeWarningPopup() {
    document.getElementById('warningPopup').style.display = 'none';
}
