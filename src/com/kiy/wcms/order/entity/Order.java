package com.kiy.wcms.order.entity;

import java.util.Date;

import com.kiy.wcms.sys.entity.SysUser;

/**
 * 订单附件
 * @author Kiy Peng
 * @date 2014年8月22日
 */
public class Order {
	/**
	 * 主键
	 */
	private int id;
	/**
	 * 订单编号
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
	 * 联系人
	 */
	private String linkman;
	/**
	 * 联系电话
	 */
	private String phone;
	/**
	 * 签单人
	 */
	private int signerId;
	private String signerName;
	/**
	 * 签单日期
	 */
	private String signDate;
	/**
	 * 交付日期
	 */
	private String payDate;
	/**
	 * 总额
	 */
	private double total;
	/**
	 * 状态
	 */
	private int status;
	/**
	 * 创建日期
	 */
	private Date createTime;
	/**
	 * 创建人
	 */
	private SysUser createUser;
	/**
	 * 交付地点
	 */
	private String payPlace;
	/**
	 * 质保期
	 */
	private String warrantee;
	/**
	 * 备注
	 */
	private String remark;
	
	private String processInsId;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	public String getLinkman() {
		return linkman;
	}
	public void setLinkman(String linkman) {
		this.linkman = linkman;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public int getSignerId() {
		return signerId;
	}
	public void setSignerId(int signerId) {
		this.signerId = signerId;
	}
	public String getSignDate() {
		return signDate;
	}
	public void setSignDate(String signDate) {
		this.signDate = signDate;
	}
	public String getPayDate() {
		return payDate;
	}
	public void setPayDate(String payDate) {
		this.payDate = payDate;
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
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public SysUser getCreateUser() {
		return createUser;
	}
	public void setCreateUser(SysUser createUser) {
		this.createUser = createUser;
	}
	public String getPayPlace() {
		return payPlace;
	}
	public void setPayPlace(String payPlace) {
		this.payPlace = payPlace;
	}
	public String getWarrantee() {
		return warrantee;
	}
	public void setWarrantee(String warrantee) {
		this.warrantee = warrantee;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getSignerName() {
		return signerName;
	}
	public void setSignerName(String signerName) {
		this.signerName = signerName;
	}
	public String getProcessInsId() {
		return processInsId;
	}
	public void setProcessInsId(String processInsId) {
		this.processInsId = processInsId;
	}
}
