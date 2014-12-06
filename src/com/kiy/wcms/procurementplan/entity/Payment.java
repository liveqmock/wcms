package com.kiy.wcms.procurementplan.entity;

public class Payment {
	private int id;
	private int contractId;
	private int applyUser;
	private String applyUserName;
	private long applyDate;
	private String applyDateStr;
	private String applyReason;
	/**
	 * 收款账户名
	 */
	private String accountName;
	/**
	 * 收款账号
	 */
	private String accountNo;
	
	private int createUser;
	private long createDate;
	private String remark;
	private int status;
	/**
	 * 付款金额
	 */
	private double total;
	
	private String code;
	
	/**
	 * 付款申请单审批展示数据
	 */
	private String contractCode;
	
	private Double contractSum;
	
	private String departName;
	/**
	 * 开票金额
	 */
	private Double bill;
	/**
	 * 已开票金额
	 */
	private Double hadBill;
	/**
	 * 未开票金额
	 */
	private Double unBill;
	
	public long getCreateDate() {
		return createDate;
	}
	public void setCreateDate(long createDate) {
		this.createDate = createDate;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getApplyUser() {
		return applyUser;
	}
	public void setApplyUser(int applyUser) {
		this.applyUser = applyUser;
	}
	public String getApplyUserName() {
		return applyUserName;
	}
	public void setApplyUserName(String applyUserName) {
		this.applyUserName = applyUserName;
	}
	public long getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(long applyDate) {
		this.applyDate = applyDate;
	}
	public String getApplyDateStr() {
		return applyDateStr;
	}
	public void setApplyDateStr(String applyDateStr) {
		this.applyDateStr = applyDateStr;
	}
	public String getApplyReason() {
		return applyReason;
	}
	public void setApplyReason(String applyReason) {
		this.applyReason = applyReason;
	}
	public String getAccountName() {
		return accountName;
	}
	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}
	public String getAccountNo() {
		return accountNo;
	}
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public int getCreateUser() {
		return createUser;
	}
	public void setCreateUser(int createUser) {
		this.createUser = createUser;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getContractId() {
		return contractId;
	}
	public void setContractId(int contractId) {
		this.contractId = contractId;
	}
	public String getContractCode() {
		return contractCode;
	}
	public void setContractCode(String contractCode) {
		this.contractCode = contractCode;
	}
	public Double getContractSum() {
		return contractSum;
	}
	public void setContractSum(Double contractSum) {
		this.contractSum = contractSum;
	}
	public String getDepartName() {
		return departName;
	}
	public void setDepartName(String departName) {
		this.departName = departName;
	}
	public Double getBill() {
		return bill;
	}
	public void setBill(Double bill) {
		this.bill = bill;
	}
	public Double getHadBill() {
		return hadBill;
	}
	public void setHadBill(Double hadBill) {
		this.hadBill = hadBill;
	}
	public Double getUnBill() {
		return unBill;
	}
	public void setUnBill(Double unBill) {
		this.unBill = unBill;
	}
}
