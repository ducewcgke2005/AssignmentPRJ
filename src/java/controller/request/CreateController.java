package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import model.LeaveRequest;
import model.iam.User;
import model.Employee;

@WebServlet(urlPatterns = "/request/create")
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        req.getRequestDispatcher("/view/leave/create.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String fromStr = req.getParameter("from");
        String toStr = req.getParameter("to");
        String reason = req.getParameter("reason");

        try {
            if (fromStr == null || toStr == null || reason == null || reason.trim().isEmpty()) {
                throw new IllegalArgumentException("Missing required fields");
            }

            Date fromDate = Date.valueOf(LocalDate.parse(fromStr));
            Date toDate = Date.valueOf(LocalDate.parse(toStr));

            if (toDate.before(fromDate)) {
                throw new IllegalArgumentException("End date cannot be before start date");
            }

            LeaveRequest leave = new LeaveRequest();
            Employee emp = user.getEmployee();
            leave.setCreatedBy(emp);
            leave.setCreatedTime(java.sql.Timestamp.valueOf(LocalDate.now().atStartOfDay()));
            leave.setFromDate(fromDate);
            leave.setToDate(toDate);
            leave.setReason(reason.trim());
            leave.setStatus(0); // 0 = Pending
            leave.setProcessedBy(null); // chưa ai duyệt

            LeaveRequestDBContext db = new LeaveRequestDBContext();
            db.insert(leave);

            req.setAttribute("message", "✅ Submit successful!");
            req.setAttribute("success", true);
            req.getRequestDispatcher("/view/leave/success.jsp").forward(req, resp);

        } catch (DateTimeParseException e) {
            req.setAttribute("message", "❌ Invalid date format!");
            req.setAttribute("success", false);
            req.getRequestDispatcher("/view/leave/success.jsp").forward(req, resp);

        } catch (IllegalArgumentException e) {
            req.setAttribute("message", "⚠️ " + e.getMessage());
            req.setAttribute("success", false);
            req.getRequestDispatcher("/view/leave/success.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "❌ Submit failed. Please try again!");
            req.setAttribute("success", false);
            req.getRequestDispatcher("/view/leave/success.jsp").forward(req, resp);
        }
    }
}
