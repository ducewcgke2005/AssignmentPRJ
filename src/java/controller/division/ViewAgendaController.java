package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import dal.EmployeeDBContext;
import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import model.Employee;
import model.iam.DayStatus;
import model.iam.User;

@WebServlet(urlPatterns = "/division/agenda")
public class ViewAgendaController extends BaseRequiredAuthorizationController {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
    }

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            String eid_raw = req.getParameter("eid");
            EmployeeDBContext empDB = new EmployeeDBContext();

            if (eid_raw == null || eid_raw.isEmpty()) {
                ArrayList<Employee> employees = empDB.getAll();
                req.setAttribute("employees", employees);
                req.getRequestDispatcher("/view/division/employee_list.jsp").forward(req, resp);
                return;
            }

            int eid = Integer.parseInt(eid_raw);
            Employee emp = empDB.get2(eid);
            if (emp == null) {
                req.setAttribute("message", "Khong tim thay nhan vien nay!");
                req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
                return;
            }

            // Lay thang/nam tu request (neu co)
            String year_raw = req.getParameter("year");
            String month_raw = req.getParameter("month");
            LocalDate now = LocalDate.now();
            int year = (year_raw != null && !year_raw.isEmpty()) ? Integer.parseInt(year_raw) : now.getYear();
            int month = (month_raw != null && !month_raw.isEmpty()) ? Integer.parseInt(month_raw) : now.getMonthValue();

            LeaveRequestDBContext leaveDB = new LeaveRequestDBContext();
            ArrayList<LocalDate> offDays = leaveDB.getLeaveDaysByMonth(eid, year, month);

            // ✅ Chuyen startedDate sang LocalDate
            java.util.Date startedDateRaw = emp.getStartedDate();
            LocalDate startedDate = null;
            if (startedDateRaw != null) {
                if (startedDateRaw instanceof java.sql.Date) {
                    startedDate = ((java.sql.Date) startedDateRaw).toLocalDate();
                } else {
                    startedDate = startedDateRaw.toInstant()
                            .atZone(java.time.ZoneId.systemDefault())
                            .toLocalDate();
                }
            }

            ArrayList<DayStatus> days = new ArrayList<>();
            YearMonth ym = YearMonth.of(year, month);
            for (int day = 1; day <= ym.lengthOfMonth(); day++) {
                LocalDate date = LocalDate.of(year, month, day);
                String status;

                if (startedDate != null && date.isBefore(startedDate)) {
                    status = "inactive"; // truoc ngay bat dau
                } else if (offDays.contains(date)) {
                    status = "off"; // nghi phep
                } else {
                    status = "working"; // lam viec
                }

                days.add(new DayStatus(date, status));
            }

            req.setAttribute("employee", emp);
            req.setAttribute("days", days);
            req.setAttribute("year", year);
            req.setAttribute("month", month);
            req.getRequestDispatcher("/view/division/agenda.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "Co loi xay ra khi hien thi agenda!");
            req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
        }
    }

}
