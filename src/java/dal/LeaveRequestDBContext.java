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
                SELECT r.*, e.ename AS created_name, p.ename AS processed_name
                FROM RequestForLeave r
                INNER JOIN Employee e ON e.eid = r.created_by
                LEFT JOIN Employee p ON p.eid = r.processed_by
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    public ArrayList<LeaveRequest> getByEmployeeId(int eid) {
        ArrayList<LeaveRequest> list = new ArrayList<>();
        try {
            String sql = """
                SELECT r.*, e.ename AS created_name, p.ename AS processed_name
                FROM RequestForLeave r
                INNER JOIN Employee e ON e.eid = r.created_by
                LEFT JOIN Employee p ON p.eid = r.processed_by
                WHERE r.created_by = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    public ArrayList<LeaveRequest> getBySubordinates(int managerId) {
        ArrayList<LeaveRequest> list = new ArrayList<>();
        try {
            String sql = """
                WITH Subordinates AS (
                    SELECT eid FROM Employee WHERE supervisorid = ?
                    UNION ALL
                    SELECT e.eid FROM Employee e
                    INNER JOIN Subordinates s ON e.supervisorid = s.eid
                )
                SELECT r.*, e.ename AS created_name, p.ename AS processed_name
                FROM RequestForLeave r
                INNER JOIN Employee e ON e.eid = r.created_by
                LEFT JOIN Employee p ON p.eid = r.processed_by
                WHERE r.created_by IN (SELECT eid FROM Subordinates)
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, managerId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    private LeaveRequest mapResultSet(ResultSet rs) throws SQLException {
        LeaveRequest lr = new LeaveRequest();
        lr.setId(rs.getInt("rid"));
        lr.setReason(rs.getString("reason"));
        lr.setStatus(rs.getInt("status"));
        lr.setCreatedTime(rs.getTimestamp("created_time"));
        lr.setFromDate(rs.getDate("from"));
        lr.setToDate(rs.getDate("to"));

        Employee created = new Employee();
        created.setId(rs.getInt("created_by"));
        created.setName(rs.getString("created_name"));
        lr.setCreatedBy(created);

        Integer processedId = rs.getObject("processed_by", Integer.class);
        if (processedId != null) {
            Employee processed = new Employee();
            processed.setId(processedId);
            processed.setName(rs.getString("processed_name"));
            lr.setProcessedBy(processed);
        }

        return lr;
    }

    @Override
    public LeaveRequest get(int id) {
        try {
            String sql = """
                SELECT r.*, e.ename AS created_name, p.ename AS processed_name
                FROM RequestForLeave r
                INNER JOIN Employee e ON e.eid = r.created_by
                LEFT JOIN Employee p ON p.eid = r.processed_by
                WHERE r.rid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
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
                (created_by, created_time, [from], [to], reason, status)
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
                     UPDATE [RequestForLeave]
                        SET [status] = ?,
                            [processed_by] = ?
                      WHERE [rid] = ?
                     """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getStatus());
            if (model.getProcessedBy() != null) {
                stm.setInt(2, model.getProcessedBy().getId());
            } else {
                stm.setNull(2, Types.INTEGER);
            }
            stm.setInt(3, model.getId());
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

    public boolean isSuperior(int supervisorId, int employeeId) {
        try {
            String sql = """
            WITH Subordinates AS (
                SELECT eid FROM Employee WHERE supervisorid = ?
                UNION ALL
                SELECT e.eid FROM Employee e
                INNER JOIN Subordinates s ON e.supervisorid = s.eid
            )
            SELECT 1 FROM Subordinates WHERE eid = ?
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, supervisorId);
            stm.setInt(2, employeeId);
            ResultSet rs = stm.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

}
