package com.kiy.wcms.procurementplan.entity;

import com.kiy.wcms.sys.entity.SysUser;

/**
 * 采购订单
 * @author wuwenlong
 * @date 2014年9月30日
 */
public class ProcurementContract {
	/**
	 * 主键
	 */
	private int id;
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
	private int signUser;
	/**
	 * 签单人名称
	 */
	private String signUserName;
	/**
	 * 总额
	 */
	private double sum;
	/**
	 * 创建人
	 */
	private SysUser createUser;
	/**
	 * 创建时间
	 */
	private long createDate;
	private String createDateStr;
	/**
	 * 状态
	 */
	private int status;
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
	 * 收货时间
	 */
	private long receiveTime;
	private String receiveTimeStr;
	/**
	 * 订单编号
	 */
	private String code;
	/**
	 * 名称
	 */
	private String name;
	/**
	 * 签单时间
	 */
	private long signDate;
	private String signDateStr;
	/**
	 * 采购单位
	 */
	private String company;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
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
	public int getSignUser() {
		return signUser;
	}
	public void setSignUser(int signUser) {
		this.signUser = signUser;
	}
	public String getSignUserName() {
		return signUserName;
	}
	public void setSignUserName(String signUserName) {
		this.signUserName = signUserName;
	}
	public double getSum() {
		return sum;
	}
	public void setSum(double sum) {
		this.sum = sum;
	}
	public SysUser getCreateUser() {
		return createUser;
	}
	public void setCreateUser(SysUser createUser) {
		this.createUser = createUser;
	}
	public long getCreateDate() {
		return createDate;
	}
	public void setCreateDate(long createDate) {
		this.createDate = createDate;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
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
	public long getReceiveTime() {
		return receiveTime;
	}
	public void setReceiveTime(long receiveTime) {
		this.receiveTime = receiveTime;
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
	public long getSignDate() {
		return signDate;
	}
	public void setSignDate(long signDate) {
		this.signDate = signDate;
	}
	public String getReceiveUserName() {
		return receiveUserName;
	}
	public void setReceiveUserName(String receiveUserName) {
		this.receiveUserName = receiveUserName;
	}
	public String getReceiveTimeStr() {
		return receiveTimeStr;
	}
	public void setReceiveTimeStr(String receiveTimeStr) {
		this.receiveTimeStr = receiveTimeStr;
	}
	public String getSignDateStr() {
		return signDateStr;
	}
	public void setSignDateStr(String signDateStr) {
		this.signDateStr = signDateStr;
	}
	public String getCreateDateStr() {
		return createDateStr;
	}
	public void setCreateDateStr(String createDateStr) {
		this.createDateStr = createDateStr;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
}
