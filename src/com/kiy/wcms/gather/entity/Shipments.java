package com.kiy.wcms.gather.entity;

public class Shipments {
	private int id;
	private Integer orderId;
	private String code;
	private String orderNo;
	private String orderName;
	private String signUserName;
	private Double total;
	private String signDate;
	private String clientName;
	private String payPlace;
	private String payDate;
	private String warningDate;
	private String applyUserName;
	private Integer applyUser;
	private String applyDate;
	private String shipmentsDate;
	private Integer status;
	private Integer createUser;
	private String createDate;
	private String remark;
	
	private Double gatherTotal;
	private Double orderTotal;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
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
	public String getApplyUserName() {
		return applyUserName;
	}
	public void setApplyUserName(String applyUserName) {
		this.applyUserName = applyUserName;
	}
	public Integer getApplyUser() {
		return applyUser;
	}
	public void setApplyUser(Integer applyUser) {
		this.applyUser = applyUser;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public String getShipmentsDate() {
		return shipmentsDate;
	}
	public void setShipmentsDate(String shipmentsDate) {
		this.shipmentsDate = shipmentsDate;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getCreateUser() {
		return createUser;
	}
	public void setCreateUser(Integer createUser) {
		this.createUser = createUser;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getOrderName() {
		return orderName;
	}
	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}
	public String getSignUserName() {
		return signUserName;
	}
	public void setSignUserName(String signUserName) {
		this.signUserName = signUserName;
	}
	public Double getTotal() {
		return total;
	}
	public void setTotal(Double total) {
		this.total = total;
	}
	public String getSignDate() {
		return signDate;
	}
	public void setSignDate(String signDate) {
		this.signDate = signDate;
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
	public String getPayDate() {
		return payDate;
	}
	public void setPayDate(String payDate) {
		this.payDate = payDate;
	}
	public String getWarningDate() {
		return warningDate;
	}
	public void setWarningDate(String warningDate) {
		this.warningDate = warningDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public Double getGatherTotal() {
		return gatherTotal;
	}
	public void setGatherTotal(Double gatherTotal) {
		this.gatherTotal = gatherTotal;
	}
	public Double getOrderTotal() {
		return orderTotal;
	}
	public void setOrderTotal(Double orderTotal) {
		this.orderTotal = orderTotal;
	}
}
