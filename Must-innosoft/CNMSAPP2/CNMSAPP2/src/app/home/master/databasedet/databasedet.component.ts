import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { MasterService } from '../master.service';
import { DatabaseDetails } from './databasedet';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { Company } from '../company/company';
import { Client } from '../client/client';

@Component({
  selector: 'app-databasedet',
  templateUrl: './databasedet.component.html',
  styleUrls: ['./databasedet.component.scss']
})
export class DatabasedetComponent implements OnInit {
  modalTitle: string;
  isAdd: boolean;
  companyList: Company[];
  databaseList: DatabaseDetails[];

  databaseForm: FormGroup;
  clientList: Client[];
  sampleText: NguModal;

  displayedColumns = [
    'CompanyName',
    'ClientName',
    'Server_Name',
    'DB_Name',
    'DB_Username',
    'DB_Password',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.databaseList);

  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getClient();
    this.getCompany();

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

  getClient() {
    this.ms.getClient().subscribe(res => {
      this.clientList = res;
    });
  }
  private getDatabase() {
    this.ms.getDatabase().subscribe(res => {
      console.log(res);
      this.databaseList = res;
      this.dataSource.data = this.databaseList;
    });
  }

  createForm() {
    this.databaseForm = this.fb.group({
      DatabaseId: '',
      ClientId: ['', Validators.required],
      CompanyId: ['', Validators.required],
      Server_Name: ['', Validators.required],
      DB_Name: ['', Validators.required],
      DB_Username: ['', Validators.required],
      DB_Password: ['', Validators.required],
      Status: ['', Validators.required]
    });
  }

  databaseSubmit() {
    console.log(this.databaseForm.value);
    if (this.isAdd) {
      this.ms.addDatabase(this.databaseForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getDatabase();
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
      this.ms.updateDatabase(this.databaseForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getDatabase();
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

  editDatabase(row) {
    this.modalTitle = 'Edit Database';
    this.isAdd = false;
    console.log(row);
    this.getCompany();
    this.getClient();
    this.databaseForm.patchValue({
      DatabaseId: row.DatabaseId,
      CompanyId: row.CompanyId,
      ClientId: row.ClientId,
      Server_Name: row.Server_Name,
      DB_Name: row.DB_Name,
      DB_Username: row.DB_Username,
      DB_Password: row.DB_Password,
      Status: row.Status
    });
    this.modal.open(this.sampleText.id);
  }

  addDatabase() {
    this.modalTitle = 'Add Database';
    this.isAdd = true;
    this.getDatabase();
    this.getCompany();
    this.getClient();

    this.databaseForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
