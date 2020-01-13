import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { MasterService } from '../master.service';
import { UserDetails, UserRoleRes } from './userdetails';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { Company } from '../company/company';
import { Client } from '../client/client';
import { Supplier } from '../supplier/supplier';

@Component({
  selector: 'app-userdetails',
  templateUrl: './userdetails.component.html',
  styleUrls: ['./userdetails.component.scss']
})
export class UserdetailsComponent implements OnInit {
  roleList: UserRoleRes;
  modalTitle: string;
  userForm: FormGroup;
  companyList: Company[];
  supplierList: Supplier;
  userList: UserDetails[];
  isAdd: boolean;
  clientList: Client[];
  sampleText: NguModal;
  userRole: number;
  displayedColumns = [
    'CompanyName',
    'ClientCode',
    'ClientName',
    'Username',
    'Password',
    'Role_Name',
    'Loginuser',
    'Designation',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.userList);
  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.userRole = 0;
    this.getUser();
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }

  getCompany() {
    this.ms.getCompany().subscribe(res => {
      this.companyList = res;
    });
  }

  getClient(id) {
    this.ms.getClientLite(id).subscribe(res => {
      console.log(res);
      this.clientList = res;
    });
  }
  getsupplierDet(id) {
    this.ms.getSupplierDet(id).subscribe(res => {
      console.log(res);
      this.supplierList = res;
    });
  }
  getUserRole(id) {
    this.ms.getUserRole(id).subscribe(res => {
      this.roleList = res;
    });
  }

  private getUser() {
    this.ms.getUser().subscribe(res => {
      console.log(res);
      this.userList = res;
      this.dataSource.data = this.userList;
    });
  }

  createForm() {
    this.userForm = this.fb.group({
      ClientId: ['', Validators.required],
      CompanyId: ['', Validators.required],
      ClientCode: '',
      UserId: '',
      Username: ['', Validators.required],
      Password: ['', Validators.required],
      User_Role_Id: ['', Validators.required],
      MaintanceDate: '',
      ExprieDate: '',
      Loginuser: '',
      Designation: '',
      Type: ['', Validators.required],
      SupplierId: '',
      Status: ['', Validators.required]
    });

    this.userForm.get('CompanyId').valueChanges.subscribe(res => {
      this.getClient(res);
    });
    this.userForm.get('Type').valueChanges.subscribe(res => {
      console.log(res);
      if (res !== '0') {
        this.getsupplierDet(res);
      }
    });
  }

  userSubmit() {
    console.log(this.userForm.value);
    if (this.isAdd) {
      this.ms.addUser(this.userForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getUser();
          this.userRole = 0;
        } else {
          this.alert.open({
            heading: 'Saving Failed',
            msg: res.message,
            type: 'danger',
            duration: 5000
          });
        }
      });
    } else {
      this.ms.updateUser(this.userForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getUser();
          this.userRole = 0;
        } else {
          this.alert.open({
            heading: 'Update Failed',
            msg: res.message,
            type: 'danger',
            duration: 5000
          });
        }
      });
    }
  }

  openModal() {
    this.modal.open(this.sampleText.id);
  }

  closeModal() {
    this.modal.close(this.sampleText.id);
  }

  editUser(row) {
    this.modalTitle = 'Edit User';
    this.isAdd = false;
    console.log(row);
    this.getCompany();
    this.getClient(row.CompanyId);
    if (row.User_Role_Id === 2) {
      this.userRole = 1;
    } else {
      this.userRole = 0;
    }

    console.log(this.userRole);
    this.userForm.patchValue({
      ClientId: row.ClientId,
      CompanyId: row.CompanyId,
      ClientCode: row.ClientCode,
      ClientName: row.ClientName,
      UserId: row.UserId,
      Username: row.Username,
      Password: row.Password,
      User_Role_Id: row.User_Role_Id,
      MaintanceDate: row.MaintanceDate,
      ExprieDate: row.ExprieDate,
      Created_by: row.Created_by,
      CreateDate: row.CreateDate,
      Modified_by: row.Modified_by,
      Modfied_Date: row.Modfied_Date,
      Loginuser: row.Loginuser,
      Designation: row.Designation,
      Status: row.Status,
      Type: row.Type,
      SupplierId: row.SupplierId
    });

    this.getUserRole(0);
    this.modal.open(this.sampleText.id);
    // this.companyForm.reset();
  }

  addUser() {
    this.modalTitle = 'Add User';
    this.isAdd = true;
    this.getCompany();
    this.getUser();
    this.userForm.reset();
    this.getUserRole(0);
    this.modal.open(this.sampleText.id);
    this.userRole = 0;
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
