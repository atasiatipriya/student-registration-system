// ── DATA STORE ──
// This array acts like a temporary database in the browser
let students = [];

// ── REGISTER STUDENT ──
function registerStudent() {

  // Step 1: Read values from the form fields
  const name   = document.getElementById('studentName').value.trim();
  const email  = document.getElementById('studentEmail').value.trim();
  const phone  = document.getElementById('studentPhone').value.trim();
  const course = document.getElementById('studentCourse').value;
  const year   = document.getElementById('studentYear').value;
  const dob    = document.getElementById('studentDOB').value;

  // Step 2: Validate - check if all fields are filled correctly
  const isValid = validateForm(name, email, phone, course, year, dob);

  // Step 3: If not valid, stop here
  if (!isValid) return;

  // Step 4: Create a student object
  const newStudent = {
    id:     students.length + 1,
    name:   name,
    email:  email,
    phone:  phone,
    course: course,
    year:   year,
    dob:    formatDate(dob)
  };

  // Step 5: Add to our students array (simulates saving to a database)
  students.push(newStudent);

  // Step 6: Refresh the table to show the new student
  renderTable(students);

  // Step 7: Show success message
  showSuccess();

  // Step 8: Clear the form
  clearForm();
}

// ── VALIDATE FORM ──
function validateForm(name, email, phone, course, year, dob) {
  let isValid = true;

  // Clear all previous errors first
  clearErrors();

  // Name: must not be empty and only letters/spaces
  if (name === '') {
    showError('nameError', 'studentName', 'Name is required.');
    isValid = false;
  } else if (!/^[a-zA-Z\s]+$/.test(name)) {
    showError('nameError', 'studentName', 'Name must contain only letters.');
    isValid = false;
  }

  // Email: must match email format
  if (email === '') {
    showError('emailError', 'studentEmail', 'Email is required.');
    isValid = false;
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    showError('emailError', 'studentEmail', 'Enter a valid email address.');
    isValid = false;
  }

  // Phone: must be exactly 10 digits
  if (phone === '') {
    showError('phoneError', 'studentPhone', 'Phone number is required.');
    isValid = false;
  } else if (!/^\d{10}$/.test(phone)) {
    showError('phoneError', 'studentPhone', 'Phone must be exactly 10 digits.');
    isValid = false;
  }

  // Course: must be selected
  if (course === '') {
    showError('courseError', 'studentCourse', 'Please select a course.');
    isValid = false;
  }

  // Year: must be selected
  if (year === '') {
    showError('yearError', 'studentYear', 'Please select a year.');
    isValid = false;
  }

  // Date of Birth: must not be empty
  if (dob === '') {
    showError('dobError', 'studentDOB', 'Date of birth is required.');
    isValid = false;
  }

  return isValid;
}

// ── HELPER: Show one error ──
function showError(errorId, fieldId, message) {
  document.getElementById(errorId).textContent = message;
  document.getElementById(fieldId).classList.add('error-field');
}

// ── HELPER: Clear all errors ──
function clearErrors() {
  const errorIds = ['nameError', 'emailError', 'phoneError', 'courseError', 'yearError', 'dobError'];
  const fieldIds = ['studentName', 'studentEmail', 'studentPhone', 'studentCourse', 'studentYear', 'studentDOB'];

  errorIds.forEach(id => document.getElementById(id).textContent = '');
  fieldIds.forEach(id => document.getElementById(id).classList.remove('error-field'));
}

// ── RENDER TABLE ──
// Takes an array of students and builds the table rows
function renderTable(data) {
  const tbody     = document.getElementById('tableBody');
  const emptyMsg  = document.getElementById('emptyMsg');
  const countBadge = document.getElementById('studentCount');

  // Update student count badge
  countBadge.textContent = students.length;

  // If no students, show the empty message
  if (data.length === 0) {
    tbody.innerHTML = '';
    emptyMsg.style.display = 'block';
    return;
  }

  emptyMsg.style.display = 'none';

  // Build table rows
  tbody.innerHTML = data.map((s, index) => `
    <tr>
      <td>${index + 1}</td>
      <td>${s.name}</td>
      <td>${s.email}</td>
      <td>${s.phone}</td>
      <td>${s.course}</td>
      <td>${s.year}</td>
      <td>${s.dob}</td>
      <td>
        <button class="delete-btn" onclick="deleteStudent(${s.id})">Delete</button>
      </td>
    </tr>
  `).join('');
}

// ── DELETE STUDENT ──
function deleteStudent(id) {
  // Filter out the student with the matching id
  students = students.filter(s => s.id !== id);
  // Re-render the table
  renderTable(students);
}

// ── SEARCH STUDENTS ──
function searchStudents() {
  const query = document.getElementById('searchInput').value.toLowerCase();

  // Filter students whose name or course matches the search query
  const filtered = students.filter(s =>
    s.name.toLowerCase().includes(query) ||
    s.course.toLowerCase().includes(query)
  );

  renderTable(filtered);
}

// ── CLEAR FORM ──
function clearForm() {
  document.getElementById('studentName').value   = '';
  document.getElementById('studentEmail').value  = '';
  document.getElementById('studentPhone').value  = '';
  document.getElementById('studentCourse').value = '';
  document.getElementById('studentYear').value   = '';
  document.getElementById('studentDOB').value    = '';
  clearErrors();
}

// ── SHOW SUCCESS BANNER ──
function showSuccess() {
  const banner = document.getElementById('successBanner');
  banner.style.display = 'block';
  // Hide it automatically after 3 seconds
  setTimeout(() => {
    banner.style.display = 'none';
  }, 3000);
}

// ── FORMAT DATE ──
// Converts "2003-06-15" to "15 Jun 2003"
function formatDate(dateStr) {
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-GB', {
    day: '2-digit', month: 'short', year: 'numeric'
  });
}

// ── INITIALIZE ──
// Run when the page first loads
renderTable(students);