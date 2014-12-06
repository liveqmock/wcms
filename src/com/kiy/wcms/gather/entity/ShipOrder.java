package com.kiy.wcms.gather.entity;

public class ShipOrder {
	private int orderId;
	private String orderNo;
	private String clientName;
	private String linkman;
	private String phone;
	private String payPlace;
	private String signUser;
	private double surplus;
	
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getClientName() {
		return clientName;
	}
	public void setClientName(String clientName) {
		this.clientName = clientName;
	}
	public String getLinkman() {
		return linkman;
	}
	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getPayPlace() {
		return payPlace;
	}
	public void setPayPlace(String payPlace) {
		this.payPlace = payPlace;
	}
	public String getSignUser() {
		return signUser;
	}
	public void setSignUser(String signUser) {
		this.signUser = signUser;
	}
	public double getSurplus() {
		return surplus;
	}
	public void setSurplus(double surplus) {
		this.surplus = surplus;
	}
}
