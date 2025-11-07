/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.request;

import controller.iam.BaseRequiredAuthorizationController;
import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.LeaveRequest;
import model.iam.User;

/**
 *
 * @author ADMIN
 */
@WebServlet("/request/search")
public class SearchRequestController extends BaseRequiredAuthorizationController {

    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String ten = req.getParameter("name");
        if (ten == null || ten.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/request/list");
            return;
        }

        int page = 1;
        int pageSize = 5;
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (NumberFormatException e) {
        }

        LeaveRequestDBContext db = new LeaveRequestDBContext();
        ArrayList<LeaveRequest> list;
        int totalRecords;
        String roleName = user.getRoles().get(0).getName();

        if ("IT Head".equalsIgnoreCase(roleName)) {
            list = db.listByName(ten, page, pageSize);
            totalRecords = db.countByName(ten);
        } else {
            list = db.listBySupervisorAndName(user.getId(), ten, page, pageSize);
            totalRecords = db.countBySupervisorAndName(user.getId(), ten);
        }

        int totalPages = (int) Math.ceil(totalRecords * 1.0 / pageSize);

        req.setAttribute("requests", list);
        req.setAttribute("keyword", ten);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("/view/leave/listbyname.jsp").forward(req, resp);
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        processGet(req, resp, user);
    }
}
