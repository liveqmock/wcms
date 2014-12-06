package com.kiy.wcms.order.entity;


/**
 * 订单查询参数
 * @author Kiy Peng
 * @date 2014年8月22日
 */
public class OrderParam {
	/**
	 * 起始脚标
	 */
	private int begin;
	/**
	 * 每页显示条数
	 */
	private int rows;
	/**
	 * 订单号
	 */
	private String no;
	/**
	 * 订单名称
	 */
	private String name;
	/**
	 * 客户名称
	 */
	private String clientName;
	/**
	 * 签单人
	 */
	private Integer signer;
	/**
	 * 签单日期  开始
	 */
	private String signDateBegin;
	/**
	 * 签单日期  结束
	 */
	private String signDateEnd;
	/**
	 * 交付日期  开始
	 */
	private String payDateBegin;
	/**
	 * 交付日期  结束
	 */
	private String payDateEnd;
	/**
	 * 总额开始
	 */
	private Double totalBegin;
	/**
	 * 总额结束
	 */
	private Double totalEnd;
	
	private Integer status;
	
	private String seeStatus;
	
	private Integer auditStatus;
	
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
	public String getNo() {
		return no;
	}
	public void setNo(String no) {
		this.no = no;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
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
