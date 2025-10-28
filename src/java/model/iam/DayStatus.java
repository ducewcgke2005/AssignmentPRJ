/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.iam;

import java.time.LocalDate;

public class DayStatus {
    private LocalDate date;
    private String status; // "working" hoặc "off"

    public DayStatus(LocalDate date, String status) {
        this.date = date;
        this.status = status;
    }

    public LocalDate getDate() { return date; }
    public String getStatus() { return status; }
}
