package com.kiy.wcms.procurementplan.entity;

public class PaymentParam {
	private int begin,rows;
	
	private String seeStatus;
	
	private Integer auditStatus;
	
	private String contractNo,contractName,supplierName;
	
	private Integer signUser;
	
	private Long signDateBegin,signDateEnd,receiveDateBegin,receiveDateEnd;
	private String signDateBeginStr,signDateEndStr,receiveDateBeginStr,receiveDateEndStr;
	
	private Double totalBegin, totalEnd;

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

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getContractName() {
		return contractName;
	}

	public void setContractName(String contractName) {
		this.contractName = contractName;
	}

	public String getSupplierName() {
		return supplierName;
	}

	public void setSupplierName(String supplierName) {
		this.supplierName = supplierName;
	}

	public Integer getSignUser() {
		return signUser;
	}

	public void setSignUser(Integer signUser) {
		this.signUser = signUser;
	}

	public Long getSignDateBegin() {
		return signDateBegin;
	}

	public void setSignDateBegin(Long signDateBegin) {
		this.signDateBegin = signDateBegin;
	}

	public Long getSignDateEnd() {
		return signDateEnd;
	}

	public void setSignDateEnd(Long signDateEnd) {
		this.signDateEnd = signDateEnd;
	}

	public Long getReceiveDateBegin() {
		return receiveDateBegin;
	}

	public void setReceiveDateBegin(Long receiveDateBegin) {
		this.receiveDateBegin = receiveDateBegin;
	}

	public Long getReceiveDateEnd() {
		return receiveDateEnd;
	}

	public void setReceiveDateEnd(Long receiveDateEnd) {
		this.receiveDateEnd = receiveDateEnd;
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

	public String getSignDateBeginStr() {
		return signDateBeginStr;
	}

	public void setSignDateBeginStr(String signDateBeginStr) {
		this.signDateBeginStr = signDateBeginStr;
	}

	public String getSignDateEndStr() {
		return signDateEndStr;
	}

	public void setSignDateEndStr(String signDateEndStr) {
		this.signDateEndStr = signDateEndStr;
	}

	public String getReceiveDateBeginStr() {
		return receiveDateBeginStr;
	}

	public void setReceiveDateBeginStr(String receiveDateBeginStr) {
		this.receiveDateBeginStr = receiveDateBeginStr;
	}

	public String getReceiveDateEndStr() {
		return receiveDateEndStr;
	}

	public void setReceiveDateEndStr(String receiveDateEndStr) {
		this.receiveDateEndStr = receiveDateEndStr;
	}
}
