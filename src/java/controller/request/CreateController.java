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
import model.leave.LeaveRequest;
import model.iam.User;
import model.Employee;

@WebServlet(urlPatterns = "/request/create")
public class CreateController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        // Khi người dùng truy cập GET → hiển thị form nhập đơn xin nghỉ
        req.getRequestDispatcher("/view/leave/create.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        String fromStr = req.getParameter("from");
        String toStr = req.getParameter("to");
        String reason = req.getParameter("reason");

        try {
            // Chuyển đổi kiểu dữ liệu
            Date fromDate = Date.valueOf(fromStr);
            Date toDate = Date.valueOf(toStr);

            // Tạo đối tượng LeaveRequest để lưu
            LeaveRequest leave = new LeaveRequest();
            Employee emp = user.getEmployee();
            leave.setCreatedBy(emp);
            leave.setCreatedTime(java.sql.Timestamp.valueOf(LocalDate.now().atStartOfDay()));
            leave.setFromDate(fromDate);
            leave.setToDate(toDate);
            leave.setReason(reason);
            leave.setStatus(0); // 0 = pending

            // Gọi DBContext để insert
            LeaveRequestDBContext db = new LeaveRequestDBContext();
            db.insert(leave);

            // Nếu insert thành công → chuyển sang trang thông báo
            req.setAttribute("message", "Submit Successful!");
            req.getRequestDispatcher("/view/leave/success.jsp").forward(req, resp);

        } catch (Exception e) {
            // Nếu có lỗi → hiển thị trang thông báo lỗi
            req.setAttribute("message", "Submit Failed. Please try again!");
            req.getRequestDispatcher("/view/leave/success.jsp").forward(req, resp);
        }
    }

}
