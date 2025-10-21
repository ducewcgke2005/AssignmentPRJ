package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.leave.LeaveRequest;
import model.Employee;

public class LeaveRequestDBContext extends DBContext<LeaveRequest> {

    @Override
    public ArrayList<LeaveRequest> list() {
        ArrayList<LeaveRequest> list = new ArrayList<>();
        try {
            String sql = """
                SELECT r.rid, r.created_by, r.created_time, r.[from], r.[to], 
                       r.reason, r.status,
                       e.eid, e.ename
                FROM RequestForLeave r
                INNER JOIN Employee e ON r.created_by = e.eid
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                LeaveRequest lr = new LeaveRequest();
                lr.setId(rs.getInt("rid"));
                lr.setReason(rs.getString("reason"));
                lr.setStatus(rs.getInt("status"));
                lr.setCreatedTime(rs.getTimestamp("created_time"));
                lr.setFromDate(rs.getDate("from"));
                lr.setToDate(rs.getDate("to"));

                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                lr.setCreatedBy(e);

                list.add(lr);
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    @Override
    public LeaveRequest get(int id) {
        try {
            String sql = """
                SELECT r.rid, r.created_by, r.created_time, r.[from], r.[to],
                       r.reason, r.status,
                       e.eid, e.ename
                FROM RequestForLeave r
                INNER JOIN Employee e ON r.created_by = e.eid
                WHERE r.rid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                LeaveRequest lr = new LeaveRequest();
                lr.setId(rs.getInt("rid"));
                lr.setReason(rs.getString("reason"));
                lr.setStatus(rs.getInt("status"));
                lr.setCreatedTime(rs.getTimestamp("created_time"));
                lr.setFromDate(rs.getDate("from"));
                lr.setToDate(rs.getDate("to"));

                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                lr.setCreatedBy(e);
                return lr;
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public void insert(LeaveRequest model) {
        try {
            String sql = """
                INSERT INTO RequestForLeave
                ([created_by], [created_time], [from], [to], [reason], [status])
                VALUES (?, GETDATE(), ?, ?, ?, ?)
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getCreatedBy().getId());
            stm.setDate(2, new java.sql.Date(model.getFromDate().getTime()));
            stm.setDate(3, new java.sql.Date(model.getToDate().getTime()));
            stm.setString(4, model.getReason());
            stm.setInt(5, model.getStatus());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void update(LeaveRequest model) {
        try {
            String sql = """
                UPDATE RequestForLeave
                SET [from] = ?, [to] = ?, [reason] = ?, [status] = ?
                WHERE rid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setDate(1, new java.sql.Date(model.getFromDate().getTime()));
            stm.setDate(2, new java.sql.Date(model.getToDate().getTime()));
            stm.setString(3, model.getReason());
            stm.setInt(4, model.getStatus());
            stm.setInt(5, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void delete(LeaveRequest model) {
        try {
            String sql = "DELETE FROM RequestForLeave WHERE rid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }
}
