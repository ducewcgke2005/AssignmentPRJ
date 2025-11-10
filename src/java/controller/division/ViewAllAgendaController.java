package controller.division;

import controller.iam.BaseRequiredAuthorizationController;
import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Employee;
import model.iam.DayStatus;
import dal.EmployeeDBContext;
import dal.LeaveRequestDBContext;
import java.time.DayOfWeek;
import model.EmployeeAgenda;
import model.iam.User;

@WebServlet(name = "ViewAllAgendaController", urlPatterns = {"/division/agendaall"})
public class ViewAllAgendaController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            EmployeeDBContext empDB = new EmployeeDBContext();
            LeaveRequestDBContext leaveDB = new LeaveRequestDBContext();

            // --- Lấy tất cả nhân viên ---
            ArrayList<Employee> employees = empDB.getEmpByDivision(user.getId()); // Hoặc getEmpByDivision(userId)
            req.setAttribute("employees", employees);

            // --- Ngày hiện tại ---
            LocalDate today = LocalDate.now();

            // --- Tạo danh sách tuần từ thứ 2 → chủ nhật ---
            ArrayList<LocalDate[]> weeks = new ArrayList<>();
            LocalDate thisWeekMonday = today.with(DayOfWeek.MONDAY);
            int weeksBefore = 12; // số tuần trước tuần hiện tại
            int weeksAfter = 4;   // số tuần sau

            for (int i = weeksBefore; i >= 1; i--) {
                LocalDate weekStart = thisWeekMonday.minusWeeks(i);
                LocalDate weekEnd = weekStart.plusDays(6);
                weeks.add(new LocalDate[]{weekStart, weekEnd});
            }
            weeks.add(new LocalDate[]{thisWeekMonday, thisWeekMonday.plusDays(6)});
            for (int i = 1; i <= weeksAfter; i++) {
                LocalDate weekStart = thisWeekMonday.plusWeeks(i);
                LocalDate weekEnd = weekStart.plusDays(6);
                weeks.add(new LocalDate[]{weekStart, weekEnd});
            }
            req.setAttribute("weeks", weeks);

            // --- Tuần chọn ---
            String selectedWeek = req.getParameter("week");
            LocalDate weekFrom, weekTo;
            if (selectedWeek != null && !selectedWeek.isEmpty()) {
                String[] parts = selectedWeek.split("_");
                weekFrom = LocalDate.parse(parts[0]);
                weekTo = LocalDate.parse(parts[1]);
            } else {
                weekFrom = thisWeekMonday;
                weekTo = thisWeekMonday.plusDays(6);
            }

            // --- Tạo agenda cho từng nhân viên ---
            ArrayList<EmployeeAgenda> agendas = new ArrayList<>();
            for (Employee emp : employees) {

                // --- Lấy tất cả ngày nghỉ trong tuần hiển thị ---
                ArrayList<LocalDate> offDays = leaveDB.getLeaveDaysInRange(emp.getId(), weekFrom, weekTo);

                // --- Chuyển startedDate sang LocalDate ---
                LocalDate startedDate = null;
                if (emp.getStartedDate() != null)
                    startedDate = emp.getStartedDate().toInstant()
                                    .atZone(java.time.ZoneId.systemDefault())
                                    .toLocalDate();

                ArrayList<DayStatus> days = new ArrayList<>();
                LocalDate date = weekFrom;
                while (!date.isAfter(weekTo)) {
                    String status;
                    if (startedDate != null && date.isBefore(startedDate))
                        status = "inactive";
                    else if (date.isAfter(today))
                        status = "future";
                    else if (offDays.contains(date))
                        status = "off";
                    else
                        status = "working";

                    days.add(new DayStatus(date, status));
                    date = date.plusDays(1);
                }
                agendas.add(new EmployeeAgenda(emp, days));
            }

            req.setAttribute("agendas", agendas);
            req.setAttribute("weekFrom", weekFrom);
            req.setAttribute("weekTo", weekTo);

            // --- Forward sang JSP ---
            req.getRequestDispatcher("/view/division/agenda_all.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "Co loi xay ra khi hien thi agenda!");
            req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
