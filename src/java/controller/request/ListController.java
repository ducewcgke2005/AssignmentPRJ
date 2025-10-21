package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.iam.User;
import model.LeaveRequest;

@WebServlet("/request/list")
public class ListController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        LeaveRequestDBContext db = new LeaveRequestDBContext();
        String view = req.getParameter("view");
        ArrayList<LeaveRequest> list;

        if (view == null || view.equals("mine")) {
            list = db.getByEmployeeId(user.getEmployee().getId());
        } else {
            list = db.getBySubordinates(user.getEmployee().getId());
        }

        req.setAttribute("requests", list);
        req.setAttribute("viewType", view);
        req.getRequestDispatcher("/view/leave/list.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user) {}
}
