package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.LeaveRequest;

public class LeaveRequestDBContext extends DBContext<LeaveRequest> {

    @Override
    public ArrayList<LeaveRequest> list() {
        ArrayList<LeaveRequest> list = new ArrayList<>();
        try {
            String sql = """
                SELECT r.rid, r.created_by, r.created_time, r.[from], r.[to], 
                       r.reason, r.status, r.processed_by,
                       e.eid AS created_eid, e.ename AS created_ename,
                       p.eid AS processed_eid, p.ename AS processed_ename
                FROM RequestForLeave r
                INNER JOIN Employee e ON r.created_by = e.eid
                LEFT JOIN Employee p ON r.processed_by = p.eid
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

                // Thông tin người tạo đơn
                Employee creator = new Employee();
                creator.setId(rs.getInt("created_eid"));
                creator.setName(rs.getString("created_ename"));
                lr.setCreatedBy(creator);

                // Thông tin người duyệt (nếu có)
                int processedId = rs.getInt("processed_by");
                if (!rs.wasNull()) {
                    Employee processor = new Employee();
                    processor.setId(processedId);
                    processor.setName(rs.getString("processed_ename"));
                    lr.setProcessedBy(processor);
                }

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
                       r.reason, r.status, r.processed_by,
                       e.eid AS created_eid, e.ename AS created_ename,
                       p.eid AS processed_eid, p.ename AS processed_ename
                FROM RequestForLeave r
                INNER JOIN Employee e ON r.created_by = e.eid
                LEFT JOIN Employee p ON r.processed_by = p.eid
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

                Employee creator = new Employee();
                creator.setId(rs.getInt("created_eid"));
                creator.setName(rs.getString("created_ename"));
                lr.setCreatedBy(creator);

                int processedId = rs.getInt("processed_by");
                if (!rs.wasNull()) {
                    Employee processor = new Employee();
                    processor.setId(processedId);
                    processor.setName(rs.getString("processed_ename"));
                    lr.setProcessedBy(processor);
                }

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
                ([created_by], [created_time], [from], [to], [reason], [status], [processed_by])
                VALUES (?, GETDATE(), ?, ?, ?, ?, NULL)
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
                SET [from] = ?, [to] = ?, [reason] = ?, [status] = ?, [processed_by] = ?
                WHERE rid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setDate(1, new java.sql.Date(model.getFromDate().getTime()));
            stm.setDate(2, new java.sql.Date(model.getToDate().getTime()));
            stm.setString(3, model.getReason());
            stm.setInt(4, model.getStatus());
            if (model.getProcessedBy() != null)
                stm.setInt(5, model.getProcessedBy().getId());
            else
                stm.setNull(5, Types.INTEGER);
            stm.setInt(6, model.getId());
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
