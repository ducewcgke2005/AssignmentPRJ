/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.iam.User;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.iam.Role;

/**
 *
 * @author sonnt
 */
public class UserDBContext extends DBContext<User> {

    public User get(String username, String password) {
    try {
        String sql = """
            SELECT
                u.uid,
                u.username,
                u.displayname,
                e.eid,
                e.ename
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
            // Tao doi tuong User
            User u = new User();
            u.setId(rs.getInt("uid"));
            u.setUsername(rs.getString("username"));
            u.setDisplayname(rs.getString("displayname"));

            // Tao doi tuong Employee
            Employee e = new Employee();
            e.setId(rs.getInt("eid"));
            e.setName(rs.getString("ename"));
            u.setEmployee(e);

            // ✅ Lay danh sach role cua user
            ArrayList<Role> roles = new ArrayList<>();
            String sqlRole = """
                SELECT r.rid, r.rname
                FROM [Role] r
                INNER JOIN [UserRole] ur ON r.rid = ur.rid
                WHERE ur.uid = ?
            """;
            try (PreparedStatement stmRole = connection.prepareStatement(sqlRole)) {
                stmRole.setInt(1, u.getId());
                try (ResultSet rsRole = stmRole.executeQuery()) {
                    while (rsRole.next()) {
                        Role r = new Role();
                        r.setId(rsRole.getInt("rid"));
                        r.setName(rsRole.getString("rname"));
                        roles.add(r);
                    }
                    u.setRoles(roles);
                }
            }

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
    public ArrayList<User> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public User get(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void insert(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
