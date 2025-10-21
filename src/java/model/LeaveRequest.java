package model.leave;

import java.util.Date;
import model.BaseModel;
import model.Employee;

public class LeaveRequest extends BaseModel {
    private Employee createdBy;
    private Date createdTime;
    private Date fromDate;
    private Date toDate;
    private String reason;
    private int status; // 0 = Inprogress, 1 = Approved, 2 = Rejected

    public LeaveRequest() {
    }

    public LeaveRequest(int id, Employee createdBy, Date createdTime, Date fromDate, Date toDate, String reason, int status) {
        super.setId(id);
        this.createdBy = createdBy;
        this.createdTime = createdTime;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.reason = reason;
        this.status = status;
    }

    public Employee getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Employee createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Date createdTime) {
        this.createdTime = createdTime;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
