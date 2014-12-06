package com.kiy.wcms.gather.entity;

public class GatherOrder {
	private int orderId;
	private String orderNo;
	private String orderName;
	private String clientName;
	private String signDate;
	private String signUser;
	/**
	 * 总额
	 */
	private double total;
	/**
	 * 已收款
	 */
	private double hadTotal;
	/**
	 * 未收款
	 */
	private double unTotal;
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
	public String getSignDate() {
		return signDate;
	}
	public void setSignDate(String signDate) {
		this.signDate = signDate;
	}
	public String getSignUser() {
		return signUser;
	}
	public void setSignUser(String signUser) {
		this.signUser = signUser;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	public double getHadTotal() {
		return hadTotal;
	}
	public void setHadTotal(double hadTotal) {
		this.hadTotal = hadTotal;
	}
	public double getUnTotal() {
		return unTotal;
	}
	public void setUnTotal(double unTotal) {
		this.unTotal = unTotal;
	}
	public String getOrderName() {
		return orderName;
	}
	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}
}
