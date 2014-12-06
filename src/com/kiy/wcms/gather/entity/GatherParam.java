package com.kiy.wcms.gather.entity;

public class GatherParam {
	private int begin,rows;
	
	private String seeStatus;
	
	private Integer auditStatus;
	
	private String orderNo;
	
	private String orderName;
	
	private String clientName;
	
	private Integer signUser;
	
	private String signDateBegin;
	
	private String signDateEnd;
	
	private String payDateBegin;
	
	private String payDateEnd;
	
	private Double totalBegin;
	
	private Double totalEnd;
	
	private int status;//0:全部   1:未结清  2:已结清

	public int getBegin() {
		return begin;
	}

	public void setBegin(int begin) {
		this.begin = begin;
	}

	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	public Integer getSignUser() {
		return signUser;
	}

	public void setSignUser(Integer signUser) {
		this.signUser = signUser;
	}

	public String getSignDateBegin() {
		return signDateBegin;
	}

	public void setSignDateBegin(String signDateBegin) {
		this.signDateBegin = signDateBegin;
	}

	public String getSignDateEnd() {
		return signDateEnd;
	}

	public void setSignDateEnd(String signDateEnd) {
		this.signDateEnd = signDateEnd;
	}

	public String getPayDateBegin() {
		return payDateBegin;
	}

	public void setPayDateBegin(String payDateBegin) {
		this.payDateBegin = payDateBegin;
	}

	public String getPayDateEnd() {
		return payDateEnd;
	}

	public void setPayDateEnd(String payDateEnd) {
		this.payDateEnd = payDateEnd;
	}

	public Double getTotalBegin() {
		return totalBegin;
	}

	public void setTotalBegin(Double totalBegin) {
		this.totalBegin = totalBegin;
	}

	public Double getTotalEnd() {
		return totalEnd;
	}

	public void setTotalEnd(Double totalEnd) {
		this.totalEnd = totalEnd;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getSeeStatus() {
		return seeStatus;
	}

	public void setSeeStatus(String seeStatus) {
		this.seeStatus = seeStatus;
	}

	public Integer getAuditStatus() {
		return auditStatus;
	}

	public void setAuditStatus(Integer auditStatus) {
		this.auditStatus = auditStatus;
	}
}
