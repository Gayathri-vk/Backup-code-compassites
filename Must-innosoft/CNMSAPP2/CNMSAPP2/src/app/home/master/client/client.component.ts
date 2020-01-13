import { Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator, MatTableDataSource } from '@angular/material';
import { MasterService } from '../master.service';
import { Client } from './client';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { Company } from '../company/company';
import { Country } from '../country/country';
import { AuthService } from '../../../shared/core';

@Component({
  selector: 'app-client',
  templateUrl: './client.component.html',
  styleUrls: ['./client.component.scss']
})
export class ClientComponent implements OnInit {
  userRole: number;
  modalTitle: string;
  companyList: Company[];

  countryList: Country[];
  isAdd: boolean;
  clientForm: FormGroup;
  clientList: Client[];
  sampleText: NguModal;

  @ViewChild(MatPaginator)
  paginator: MatPaginator;

  displayedColumns = [
    'CompanyName',
    'ClientCode',
    'ClientName',
    'ContactPerson',
    'HandPhoneNo',
    'Country_Name',
    'NoofUser',
    'CreatedUser',
    'ExprieDate',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.clientList);

  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService,
    private auth: AuthService
  ) {}

  ngOnInit() {
    this.userRole = this.auth.userRole;
    this.getClient();
    this.getCountry();
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
    this.dataSource.paginator = this.paginator;
  }

  getCompany() {
    this.ms.getCompany().subscribe(res => {
      this.companyList = res;
    });
  }

  getCountry() {
    this.ms.getCountry().subscribe(res => {
      this.countryList = res;
    });
  }
  private getClient() {
    this.ms.getClient().subscribe(res => {
      console.log(res);
      this.clientList = res;
      this.dataSource.data = this.clientList;
    });
  }

  createForm() {
    this.clientForm = this.fb.group({
      ClientId: '',
      CompanyId: ['', Validators.required],
      ClientCode: '',
      ClientName: ['', Validators.required],
      TaxNo: '',
      GSTNo: '',
      ContactPerson: '',
      Designation: '',
      HandPhoneNo: '',
      TelePhoneNo: '',
      EmailId: '',
      Website: '',
      UintNo: '',
      Building: '',
      Street: '',
      City: '',
      State: '',
      StateCode: '',
      Pincode: '',
      CountryId: ['', Validators.required],
      NoofUser: ['', Validators.required],
      Remark: '',
      ExprieDate: ['', Validators.required],
      Status: ['', Validators.required]
    });
  }

  clientSubmit() {
    console.log(this.clientForm.value);
    if (this.isAdd) {
      this.ms.addClient(this.clientForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getClient();
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
      this.ms.updateClient(this.clientForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getClient();
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

  editClient(row) {
    if (this.userRole === 1) {
      this.modalTitle = 'Edit Client Company';

      this.isAdd = false;
      console.log(row);
      this.getCompany();
      this.getCountry();
      this.clientForm.patchValue({
        ClientId: row.ClientId,
        CompanyId: row.CompanyId,
        ClientCode: row.ClientCode,
        ClientName: row.ClientName,
        TaxNo: row.TaxNo,
        GSTNo: row.GSTNo,
        ContactPerson: row.ContactPerson,
        Designation: row.Designation,
        HandPhoneNo: row.HandPhoneNo,
        TelePhoneNo: row.TelePhoneNo,
        EmailId: row.EmailId,
        Website: row.Website,
        UintNo: row.UintNo,
        Building: row.Building,
        Street: row.Street,
        City: row.City,
        State: row.State,
        StateCode: row.StateCode,
        Pincode: row.Pincode,
        CountryId: row.CountryId,
        NoofUser: row.NoofUser,
        Remark: row.Remark,
        ExprieDate: row.ExprieDate,
        Status: row.Status
      });
      this.modal.open(this.sampleText.id);
    } else {
      alert('Edit Not Possible');
    }
    // this.companyForm.reset();
  }

  addClient() {
    this.modalTitle = 'Add Client Company';
    this.isAdd = true;
    this.getCompany();
    this.getClient();
    this.clientForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
