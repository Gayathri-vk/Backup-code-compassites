import { Component, OnInit, ViewChild } from '@angular/core';
import {
  MatTableDataSource,
  MatPaginator,
  MatCheckboxModule
} from '@angular/material';
import { MasterService } from '../master.service';
import { UserRoleRes } from '../userdetails/userdetails';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators, NgModel } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { Company } from '../company/company';
import { Client } from '../client/client';
import { UserRoleMenu, MenuDetailsRes } from './usermenu';

@Component({
  selector: 'app-usermenu',
  templateUrl: './usermenu.component.html',
  styleUrls: ['./usermenu.component.scss']
})
export class UsermenuComponent implements OnInit {
  roleList: UserRoleRes;
  menulist: MenuDetailsRes;
  modalTitle: string;
  userForm: FormGroup;
  companyList: Company[];
  usermenuList: UserRoleMenu[];
  isAdd: boolean;
  clientList: Client[];
  sampleText: NguModal;
  selectedYears: any[];

  @ViewChild(MatPaginator) paginator: MatPaginator;

  displayedColumns = [
    'CompanyName',
    'ClientName',
    'Role_Name',
    'Formname',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.usermenuList);
  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getUsermenu();
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
    this.dataSource.paginator = this.paginator;
  }
  equals(objOne, objTwo) {
    if (typeof objOne !== 'undefined' && typeof objTwo !== 'undefined') {
      return objOne.id === objTwo.id;
    }
  }

  // onChange(event) {
  //   const interests = (<FormArray>this.userForm.get('menulist')) as FormArray;

  //   if (event.checked) {
  //     interests.push(new FormControl(event.source.value));
  //   } else {
  //     const i = interests.controls.findIndex(
  //       x => x.value === event.source.value
  //     );
  //     interests.removeAt(i);
  //   }
  // }
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

  getUserRole(id) {
    this.ms.getUserRole(id).subscribe(res => {
      this.roleList = res;
    });
  }

  getMenu(id) {
    this.ms.getMenu(id).subscribe(res => {
      this.menulist = res;
    });
  }

  getUsermenu() {
    this.ms.getUsermenu().subscribe(res => {
      console.log(res);
      this.usermenuList = res;
      this.dataSource.data = this.usermenuList;
    });
  }

  createForm() {
    this.userForm = this.fb.group({
      UID: '',
      ClientId: ['', Validators.required],
      CompanyId: ['', Validators.required],
      User_RoleId: ['', Validators.required],
      MID: ['', Validators.required]
    });

    this.userForm.get('CompanyId').valueChanges.subscribe(res => {
      this.getClient(res);
    });
  }

  usermenuSubmit() {
    console.log(this.userForm.value);
    if (this.isAdd) {
      this.ms.addUsermenu(this.userForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getUsermenu();
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
      this.ms.updateUsermenu(this.userForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getUsermenu();
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
  editUsermenu(row) {
    console.log(row);
    this.ms.delItem(row, 0).subscribe(res => {
      if (res.status) {
        this.alert.open({
          heading: 'Deleted Successfully',
          msg: res.message
        });
        this.getUsermenu();
      }
    });
  }

  // editUsermenu(row) {
  //   this.modalTitle = 'Edit User Role Menu';
  //   this.isAdd = false;
  //   console.log(row);
  //   this.getCompany();
  //   this.getClient(row.CompanyId);
  //   this.userForm.patchValue({
  //     UID: row.UID,
  //     ClientId: row.ClientId,
  //     CompanyId: row.CompanyId,
  //     ClientName: row.ClientName,
  //     User_RoleId: row.User_RoleId,
  //     MID: row.MID,
  //     Status: row.Status
  //   });
  //   this.getUserRole(0);
  //   this.getMenu(0);
  //   this.modal.open(this.sampleText.id);
  //   // this.companyForm.reset();
  // }

  addUsermenu() {
    this.modalTitle = 'Add User Role Menu';
    this.isAdd = true;
    this.getCompany();
    this.getUsermenu();
    this.userForm.reset();
    this.getUserRole(0);
    this.getMenu(0);
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
