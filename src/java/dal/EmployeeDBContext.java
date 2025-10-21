package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Department;
import model.Employee;

public class EmployeeDBContext extends DBContext<Employee> {

    @Override
    public ArrayList<Employee> list() {
        ArrayList<Employee> list = new ArrayList<>();
        try {
            String sql = """
                SELECT e.eid, e.ename, e.deptid, e.supervisorid,
                       d.dname AS dept_name,
                       s.ename AS supervisor_name
                FROM Employee e
                LEFT JOIN Department d ON e.deptid = d.did
                LEFT JOIN Employee s ON e.supervisorid = s.eid
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Employee e = mapEmployee(rs);
                list.add(e);
            }

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    @Override
    public Employee get(int id) {
        try {
            String sql = """
                SELECT e.eid, e.ename, e.deptid, e.supervisorid,
                       d.dname AS dept_name,
                       s.ename AS supervisor_name
                FROM Employee e
                LEFT JOIN Department d ON e.deptid = d.did
                LEFT JOIN Employee s ON e.supervisorid = s.eid
                WHERE e.eid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapEmployee(rs);
            }

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    public ArrayList<Employee> getSubordinates(int managerId) {
        ArrayList<Employee> list = new ArrayList<>();
        try {
            String sql = """
                WITH Subordinates AS (
                    SELECT eid, ename, deptid, supervisorid
                    FROM Employee
                    WHERE supervisorid = ?
                    UNION ALL
                    SELECT e.eid, e.ename, e.deptid, e.supervisorid
                    FROM Employee e
                    INNER JOIN Subordinates s ON e.supervisorid = s.eid
                )
                SELECT s.*, d.dname AS dept_name
                FROM Subordinates s
                LEFT JOIN Department d ON s.deptid = d.did
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, managerId);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Employee e = mapEmployee(rs);
                list.add(e);
            }

        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    private Employee mapEmployee(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setId(rs.getInt("eid"));
        e.setName(rs.getString("ename"));

        // Phong ban
        int deptId = rs.getInt("deptid");
        if (!rs.wasNull()) {
            Department d = new Department();
            d.setId(deptId);
            d.setName(rs.getString("dept_name"));
            e.setDept(d);
        }

        // Cap tren
        int supervisorId = rs.getInt("supervisorid");
        if (!rs.wasNull()) {
            Employee s = new Employee();
            s.setId(supervisorId);
            s.setName(rs.getString("supervisor_name"));
            e.setSupervisor(s);
        }

        return e;
    }

    @Override
    public void insert(Employee model) {
        try {
            String sql = "INSERT INTO Employee(ename, deptid, supervisorid) VALUES (?, ?, ?)";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getName());

            if (model.getDept() != null)
                stm.setInt(2, model.getDept().getId());
            else
                stm.setNull(2, Types.INTEGER);

            if (model.getSupervisor() != null)
                stm.setInt(3, model.getSupervisor().getId());
            else
                stm.setNull(3, Types.INTEGER);

            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void update(Employee model) {
        try {
            String sql = "UPDATE Employee SET ename = ?, deptid = ?, supervisorid = ? WHERE eid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, model.getName());

            if (model.getDept() != null)
                stm.setInt(2, model.getDept().getId());
            else
                stm.setNull(2, Types.INTEGER);

            if (model.getSupervisor() != null)
                stm.setInt(3, model.getSupervisor().getId());
            else
                stm.setNull(3, Types.INTEGER);

            stm.setInt(4, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public void delete(Employee model) {
        try {
            String sql = "DELETE FROM Employee WHERE eid = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getId());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }
}
