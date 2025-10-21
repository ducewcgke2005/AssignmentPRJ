package controller.home;

import controller.iam.BaseRequiredAuthenticationController;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.iam.Role;
import model.iam.User;

@WebServlet(urlPatterns = "/home")
public class HomeController extends BaseRequiredAuthenticationController {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        // Lấy danh sách role của user
        List<Role> roles = user.getRoles();
        if (roles == null || roles.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/view/auth/login.jsp");
            return;
        }

        // Xác định dashboard theo role
        String viewPath = "/view/dashboard/employeedash.jsp"; // mặc định

        for (Role r : roles) {
            String roleName = r.getName();
            if (roleName.equalsIgnoreCase("IT Head")) {
                viewPath = "/view/dashboard/head.jsp";
                break;
            } else if (roleName.equalsIgnoreCase("IT PM")) {
                viewPath = "/view/dashboard/pmdash.jsp";
            }
        }

        req.getRequestDispatcher(viewPath).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        doGet(req, resp, user);
    }
}
