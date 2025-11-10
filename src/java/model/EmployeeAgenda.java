/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import model.iam.DayStatus;

/**
 *
 * @author ADMIN
 */
public class EmployeeAgenda {
    private Employee employee;
    private ArrayList<DayStatus> days;

    public EmployeeAgenda(Employee employee, ArrayList<DayStatus> days) {
        this.employee = employee;
        this.days = days;
    }

    public Employee getEmployee() { return employee; }
    public ArrayList<DayStatus> getDays() { return days; }
}


