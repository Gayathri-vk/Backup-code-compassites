import { Component, OnInit } from '@angular/core';
import { Supplier } from './supplier';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Company } from '../company/company';
import { Client } from '../client/client';
import { NguModal, NguModalService } from '@ngu/modal';
import { MatTableDataSource } from '@angular/material';
import { MasterService } from '../master.service';
import { NguAlertService } from '@ngu/alert';

@Component({
  selector: 'app-supplier',
  templateUrl: './supplier.component.html',
  styleUrls: ['./supplier.component.scss']
})
export class SupplierComponent implements OnInit {
  modalTitle: string;
  supplierForm: FormGroup;
  companyList: Company[];
  supplierList: Supplier[];
  isAdd: boolean;
  clientList: Client[];
  sampleText: NguModal;
  displayedColumns = [
    'CompanyName',
    'ClientName',
    'Type',
    'SupplierName',
    'SupplierAddress',
    'ContactPerson',
    'ContactNo',
    'EmailId',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.supplierList);
  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getsupplier();
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
  getsupplier() {
    this.ms.getSupplier().subscribe(res => {
      console.log(res);
      this.supplierList = res;
      this.dataSource.data = this.supplierList;
    });
  }
  createForm() {
    this.supplierForm = this.fb.group({
      ClientId: ['', Validators.required],
      CompanyId: ['', Validators.required],
      SupplierId: '',
      Type: ['', Validators.required],
      SupplierName: ['', Validators.required],
      SupplierAddress: '',
      ContactPerson: '',
      ContactNo: '',
      EmailId: '',

      Status: ['', Validators.required]
    });
    this.supplierForm.get('CompanyId').valueChanges.subscribe(res => {
      this.getClient(res);
    });
  }

  userSubmit() {
    console.log(this.supplierForm.value);
    if (this.isAdd) {
      this.ms.addSupplier(this.supplierForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getsupplier();
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
      this.ms.updateSupplier(this.supplierForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getsupplier();
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
    this.modalTitle = 'Edit Supplier/Subcontractor';
    this.isAdd = false;
    console.log(row);
    this.getCompany();
    this.getClient(row.CompanyId);
    this.supplierForm.patchValue({
      SupplierId: row.SupplierId,
      ClientId: row.ClientId,
      CompanyId: row.CompanyId,
      ClientCode: row.ClientCode,
      ClientName: row.ClientName,
      Type: row.Type,
      SupplierName: row.SupplierName,
      SupplierAddress: row.SupplierAddress,
      ContactPerson: row.ContactPerson,
      ContactNo: row.ContactNo,
      EmailId: row.EmailId,
      Status: row.Status
    });

    this.modal.open(this.sampleText.id);
  }

  addUser() {
    this.modalTitle = 'Add Supplier/Subcontractor';
    this.isAdd = true;
    this.getCompany();
    this.getsupplier();
    this.supplierForm.reset();

    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
