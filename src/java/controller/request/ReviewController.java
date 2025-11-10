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
import model.Employee;

@WebServlet("/request/review")
public class ReviewController extends BaseRequiredAuthorizationController {

//    @Override
//    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
//            throws ServletException, IOException {
//
//        String idStr = req.getParameter("id");
//        LeaveRequestDBContext db = new LeaveRequestDBContext();
//
//        String roleName = (user.getRoles() != null && !user.getRoles().isEmpty())
//                ? user.getRoles().get(0).getName()
//                : "";
//
//        if (idStr == null || idStr.isEmpty()) {
//            ArrayList<LeaveRequest> list;
//
//            if (roleName.equalsIgnoreCase("IT Head")) {
//                list = db.listBySupervisor(user.getId());
//            } else {
//                list = db.getBySubordinates(user.getEmployee().getId());
//            }
//            req.setAttribute("roleName", roleName);
//            req.setAttribute("requests", list);
//            req.getRequestDispatcher("/view/leave/reviewlist.jsp").forward(req, resp);
//
//        } else {
//            try {
//                int id = Integer.parseInt(idStr);
//                LeaveRequest lr = db.get(id);
//
//                if (lr == null) {
//                    req.setAttribute("message", "Khong tim thay don xin nghi nay!");
//                    req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
//                    return;
//                }
//                req.setAttribute("roleName", roleName);
//                req.setAttribute("request", lr);
//                req.getRequestDispatcher("/view/leave/review.jsp").forward(req, resp);
//
//            } catch (NumberFormatException e) {
//                req.setAttribute("message", "ID khong hop le!");
//                req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
//            }
//        }
//    }
    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        LeaveRequestDBContext db = new LeaveRequestDBContext();

        String roleName = (user.getRoles() != null && !user.getRoles().isEmpty())
                ? user.getRoles().get(0).getName()
                : "";

        // Nếu idStr null -> hiển thị danh sách review với phân trang
        if (idStr == null || idStr.isEmpty()) {
            int page = 1;
            int pageSize = 10; // số bản ghi mỗi trang
            String pageParam = req.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            ArrayList<LeaveRequest> list;
            int totalRecords = 0;

            if (roleName.equalsIgnoreCase("IT Head")) {
                list = db.listBySupervisorInProgress(user.getEmployee().getId(), page, pageSize);
                db = new LeaveRequestDBContext();
                totalRecords = db.countBySupervisorInProgress(user.getEmployee().getId());
            } else {
                list = db.getBySubordinatesInProgress(user.getEmployee().getId(), page, pageSize);
                db = new LeaveRequestDBContext();
                totalRecords = db.countBySubordinatesInProgress(user.getEmployee().getId());
            }

            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            req.setAttribute("roleName", roleName);
            req.setAttribute("requests", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("viewType", "all"); // hoặc tùy bạn đặt tên
            req.setAttribute("action", "request/review");
            req.setAttribute("method", "get");

            req.getRequestDispatcher("/view/leave/reviewlist.jsp").forward(req, resp);

        } else {
            // Xem chi tiết request
            try {
                int id = Integer.parseInt(idStr);
                LeaveRequest lr = db.get(id);

                if (lr == null) {
                    req.setAttribute("message", "Khong tim thay don xin nghi nay!");
                    req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("roleName", roleName);
                req.setAttribute("request", lr);
                req.getRequestDispatcher("/view/leave/review.jsp").forward(req, resp);

            } catch (NumberFormatException e) {
                req.setAttribute("message", "ID khong hop le!");
                req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String action = req.getParameter("action");

            LeaveRequest lr = new LeaveRequest();
            lr.setId(id);
            lr.setProcessedBy(user.getEmployee());

            if ("approve".equalsIgnoreCase(action)) {
                lr.setStatus(1);
            } else if ("reject".equalsIgnoreCase(action)) {
                lr.setStatus(2);
            } else {
                req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
                return;
            }
            LeaveRequestDBContext db = new LeaveRequestDBContext();
            db.update(lr);
            resp.sendRedirect(req.getContextPath() + "/request/review");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "Co loi xay ra khi xu ly don xin nghi!");
            req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
        }
    }

}
