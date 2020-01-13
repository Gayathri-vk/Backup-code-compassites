import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { MasterService } from '../master.service';
import { Company } from './company';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { AuthService } from '../../../shared/core';

@Component({
  selector: 'app-company',
  templateUrl: './company.component.html',
  styleUrls: ['./company.component.scss']
})
export class CompanyComponent implements OnInit {
  modalTitle: string;
  userRole: number;

  isAdd: boolean;
  companyForm: FormGroup;
  companyList: Company[];
  sampleText: NguModal;

  displayedColumns = [
    'CompanyName',
    'UintNo',
    'Building',
    'State',
    'Country',
    'AuthorisedPerson',
    'HandPhoneNo',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.companyList);

  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService,
    private auth: AuthService
  ) {}

  ngOnInit() {
    this.getCompany();
    this.userRole = this.auth.userRole;

    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }

  private getCompany() {
    this.ms.getCompany().subscribe(res => {
      this.companyList = res;
      this.dataSource.data = this.companyList;
    });
  }

  createForm() {
    this.companyForm = this.fb.group({
      CompanyId: '',
      CompanyName: ['', Validators.required],
      UintNo: '',
      Building: '',
      Street: '',
      City: '',
      State: '',
      StateCode: '',
      Pincode: '',
      Country: '',
      TaxNo: '',
      GSTNo: '',
      AuthorisedPerson: '',
      HandPhoneNo: '',
      TelePhoneNo: '',
      EmailId: '',
      Website: ''
    });
  }

  companySubmit() {
    console.log(this.companyForm.value);
    if (this.isAdd) {
      this.ms.addCompany(this.companyForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getCompany();
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
      this.ms.updateCompany(this.companyForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getCompany();
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

  closeModal() {
    this.modal.close(this.sampleText.id);
  }

  editCompany(row) {
    this.modalTitle = 'Edit Company';

    this.isAdd = false;
    this.companyForm.patchValue({
      CompanyId: row.CompanyId,
      CompanyName: row.CompanyName,
      UintNo: row.UintNo,
      Building: row.Building,
      Street: row.Street,
      City: row.City,
      State: row.State,
      StateCode: row.StateCode,
      Pincode: row.Pincode,
      Country: row.Country,
      TaxNo: row.TaxNo,
      GSTNo: row.GSTNo,
      AuthorisedPerson: row.AuthorisedPerson,
      HandPhoneNo: row.HandPhoneNo,
      TelePhoneNo: row.TelePhoneNo,
      EmailId: row.EmailId,
      Website: row.Website
    });
    this.modal.open(this.sampleText.id);
    // this.companyForm.reset();
  }

  addCompany() {
    this.modalTitle = 'Add Company';
    this.isAdd = true;
    this.companyForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
