package com.kiy.wcms.gather.entity;

public class Gather {
	private int id;
	private String code;
	private String orderNo;
	private double total;
	private String realname;
	private Integer gatherUser;
	private String remark;
	private String gatherDate;
	private int status;
	private Integer createUser;
	private int orderId;
	
	
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public Integer getCreateUser() {
		return createUser;
	}
	public void setCreateUser(Integer createUser) {
		this.createUser = createUser;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	public String getRealname() {
		return realname;
	}
	public void setRealname(String realname) {
		this.realname = realname;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getGatherDate() {
		return gatherDate;
	}
	public void setGatherDate(String gatherDate) {
		this.gatherDate = gatherDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Integer getGatherUser() {
		return gatherUser;
	}
	public void setGatherUser(Integer gatherUser) {
		this.gatherUser = gatherUser;
	}
}
