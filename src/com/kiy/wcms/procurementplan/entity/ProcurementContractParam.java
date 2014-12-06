package com.kiy.wcms.procurementplan.entity;

import java.util.Date;

import com.kiy.wcms.sys.entity.SysUser;
/**
 * 采购订单参数
 * @author wuwenlong
 * @date 2014年9月30日
 */
public class ProcurementContractParam {
	/**
	 * 起始页标
	 */
	private int begin;
	/**
	 * 每页显示条数
	 */
	private int rows;
	
	private int auditStatus;
	
	private String seeStatus;
	/**
	 * 主键
	 */
	private Integer id;
	/**
	 * 供应商 
	 */
	private String supplier;
	/**
	 * 供应商联系人 
	 */
	private String supplierLinkman;
	/**
	 * 供应商联系电话 
	 */
	private String supplierPhone;
	/**
	 * 签单人编号
	 */
	private Integer signUser;
	/**
	 * 签单人名称
	 */
	private String signUserName;
	/**
	 * 总额起
	 */
	private Double sumBegin;
	/**
	 * 总额止
	 */
	private Double sumEnd;
	/**
	 * 创建人
	 */
	private SysUser createUser;
	/**
	 * 创建时间
	 */
	private Date createDate;
	/**
	 * 状态
	 */
	private Integer status;
	/**
	 * 备注
	 */
	private String remark;
	/**
	 * 收货人
	 */
	private String receiveUser;
	/**
	 * 收货人名称
	 */
	private String receiveUserName;
	/**
	 * 收货时间起
	 */
	private String receiveTimeBegin;
	/**
	 * 收货时间止
	 */
	private String receiveTimeEnd;
	/**
	 * 订单编号
	 */
	private String code;
	/**
	 * 名称
	 */
	private String name;
	/**
	 * 签单时间起 
	 */
	private String signDateBegin;
	/**
	 * 签单时间止
	 */
	private String signDateEnd;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getSupplier() {
		return supplier;
	}
	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}
	public String getSupplierLinkman() {
		return supplierLinkman;
	}
	public void setSupplierLinkman(String supplierLinkman) {
		this.supplierLinkman = supplierLinkman;
	}
	public String getSupplierPhone() {
		return supplierPhone;
	}
	public void setSupplierPhone(String supplierPhone) {
		this.supplierPhone = supplierPhone;
	}
	public Integer getSignUser() {
		return signUser;
	}
	public void setSignUser(Integer signUser) {
		this.signUser = signUser;
	}
	public String getSignUserName() {
		return signUserName;
	}
	public void setSignUserName(String signUserName) {
		this.signUserName = signUserName;
	}
	public SysUser getCreateUser() {
		return createUser;
	}
	public void setCreateUser(SysUser createUser) {
		this.createUser = createUser;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getReceiveUser() {
		return receiveUser;
	}
	public void setReceiveUser(String receiveUser) {
		this.receiveUser = receiveUser;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
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
	public String getReceiveUserName() {
		return receiveUserName;
	}
	public void setReceiveUserName(String receiveUserName) {
		this.receiveUserName = receiveUserName;
	}
	public Double getSumBegin() {
		return sumBegin;
	}
	public void setSumBegin(Double sumBegin) {
		this.sumBegin = sumBegin;
	}
	public Double getSumEnd() {
		return sumEnd;
	}
	public void setSumEnd(Double sumEnd) {
		this.sumEnd = sumEnd;
	}
	public String getReceiveTimeBegin() {
		return receiveTimeBegin;
	}
	public void setReceiveTimeBegin(String receiveTimeBegin) {
		this.receiveTimeBegin = receiveTimeBegin;
	}
	public String getReceiveTimeEnd() {
		return receiveTimeEnd;
	}
	public void setReceiveTimeEnd(String receiveTimeEnd) {
		this.receiveTimeEnd = receiveTimeEnd;
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
	public int getAuditStatus() {
		return auditStatus;
	}
	public void setAuditStatus(int auditStatus) {
		this.auditStatus = auditStatus;
	}
	public String getSeeStatus() {
		return seeStatus;
	}
	public void setSeeStatus(String seeStatus) {
		this.seeStatus = seeStatus;
	}
}
