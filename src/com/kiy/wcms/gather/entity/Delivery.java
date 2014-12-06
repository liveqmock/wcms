package com.kiy.wcms.gather.entity;

public class Delivery {
	private int id;
	private int shipmentId;
	private String code;
	private String orderNo;
	private String clientName;
	private String payPlace;
	private String clientLinkman;
	private String clientLinkPhone;
	private String shipmentDate;
	private String phone;
	private String fox;
	private int linkman;
	private String linkmanName;
	private String mobile;
	private String remark;
	private int status;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getShipmentId() {
		return shipmentId;
	}
	public void setShipmentId(int shipmentId) {
		this.shipmentId = shipmentId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getShipmentDate() {
		return shipmentDate;
	}
	public void setShipmentDate(String shipmentDate) {
		this.shipmentDate = shipmentDate;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public int getLinkman() {
		return linkman;
	}
	public void setLinkman(int linkman) {
		this.linkman = linkman;
	}
	public String getLinkmanName() {
		return linkmanName;
	}
	public void setLinkmanName(String linkmanName) {
		this.linkmanName = linkmanName;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
	public String getPayPlace() {
		return payPlace;
	}
	public void setPayPlace(String payPlace) {
		this.payPlace = payPlace;
	}
	public String getClientLinkman() {
		return clientLinkman;
	}
	public void setClientLinkman(String clientLinkman) {
		this.clientLinkman = clientLinkman;
	}
	public String getClientLinkPhone() {
		return clientLinkPhone;
	}
	public void setClientLinkPhone(String clientLinkPhone) {
		this.clientLinkPhone = clientLinkPhone;
	}
	public String getFox() {
		return fox;
	}
	public void setFox(String fox) {
		this.fox = fox;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
}
