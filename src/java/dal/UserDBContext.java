package dal;

import java.util.ArrayList;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.iam.Role;
import model.iam.User;

public class UserDBContext extends DBContext<User> {

    public User get(String username, String password) {
        try {
            String sql = """
                SELECT
                    u.uid,
                    u.username,
                    u.displayname,
                    e.eid,
                    e.ename,
                    e.supervisorid
                FROM [User] u
                INNER JOIN [Enrollment] en ON u.[uid] = en.[uid]
                INNER JOIN [Employee] e ON e.eid = en.eid
                WHERE u.username = ? AND u.[password] = ?
                AND en.active = 1
            """;

            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            ResultSet rs = stm.executeQuery();

            if (rs.next()) {
                // 🧩 Tạo đối tượng User
                User u = new User();
                u.setId(rs.getInt("uid"));
                u.setUsername(rs.getString("username"));
                u.setDisplayname(rs.getString("displayname"));

                // 🧩 Tạo đối tượng Employee
                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));

                // ⚙️ Nếu có supervisor thì set vào
                int supervisorId = rs.getInt("supervisorid");
                if (!rs.wasNull()) { // tránh lỗi khi null
                    Employee sup = new Employee();
                    sup.setId(supervisorId);
                    e.setSupervisor(sup);
                }

                u.setEmployee(e);

                // 🧩 Lấy Role + Feature
                RoleDBContext roleDB = new RoleDBContext();
                ArrayList<Role> roles = roleDB.getByUserId(u.getId());
                u.setRoles(roles);

                return u;
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public ArrayList<User> list() { return null; }

    @Override
    public User get(int id) { return null; }

    @Override
    public void insert(User model) {}

    @Override
    public void update(User model) {}

    @Override
    public void delete(User model) {}
}
