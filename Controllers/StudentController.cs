using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Dapper;
using StudentRegistrationSystem.Models;

namespace StudentRegistrationSystem.Controllers
{
    public class StudentController : Controller
    {
        // This reads the connection string from appsettings.json
        private readonly string _connectionString;

        public StudentController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        // ── GET: /Student/Index
        // Shows the list of all students + the registration form
        public IActionResult Index()
        {
            var students = GetAllStudents();
            return View(students);
        }

        // ── POST: /Student/Register
        // Called when the form is submitted
        [HttpPost]
        public IActionResult Register(Student student)
        {
            if (ModelState.IsValid)
            {
                using var connection = new SqlConnection(_connectionString);
                var sql = @"INSERT INTO Students 
                            (FullName, Email, Phone, Course, YearOfStudy, DateOfBirth)
                            VALUES 
                            (@FullName, @Email, @Phone, @Course, @YearOfStudy, @DateOfBirth)";

                connection.Execute(sql, student);
                TempData["Success"] = "Student registered successfully!";
            }
            return RedirectToAction("Index");
        }

        // ── GET: /Student/Delete/5
        // Deletes a student by their ID
        public IActionResult Delete(int id)
        {
            using var connection = new SqlConnection(_connectionString);
            connection.Execute("DELETE FROM Students WHERE StudentID = @id", new { id });
            TempData["Success"] = "Student deleted successfully!";
            return RedirectToAction("Index");
        }

        // ── HELPER: Get all students from database
        private List<Student> GetAllStudents()
        {
            using var connection = new SqlConnection(_connectionString);
            var students = connection.Query<Student>(
                "SELECT * FROM Students ORDER BY CreatedAt DESC"
            ).ToList();
            return students;
        }
    }
}
