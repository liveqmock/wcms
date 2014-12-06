package com.kiy.wcms.producplan.entity;

public class ProducPlanParam {
	private int page,rows;
	private int begin;
	private String seeStatus;
	
	private int auditStatus;
	
	private String orderNo;
	
	private String clientName;
	
	private Integer signer;
	
	private String signDateBegin;
	
	private String signDateEnd;
	
	private String payDateBegin;
	
	private String payDateEnd;
	
	private String status;

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSeeStatus() {
		return seeStatus;
	}

	public void setSeeStatus(String seeStatus) {
		this.seeStatus = seeStatus;
	}

	public int getAuditStatus() {
		return auditStatus;
	}

	public void setAuditStatus(int auditStatus) {
		this.auditStatus = auditStatus;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
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

	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	public Integer getSigner() {
		return signer;
	}

	public void setSigner(Integer signer) {
		this.signer = signer;
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

	public int getBegin() {
		return begin;
	}

	public void setBegin(int begin) {
		this.begin = begin;
	}
	
}
