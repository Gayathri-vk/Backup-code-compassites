import { Component, OnInit } from '@angular/core';
// import { Company } from '../company/company';
// import { Country } from '../country/country';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ClientReg } from './client-reg';
import { NguModalService, NguModal } from '@ngu/modal';
import { NguAlertService } from '@ngu/alert';
import { Country } from '../home/master/country/country';
import { MasterService } from '../home/master/master.service';
import { AuthService } from '../shared/core';
import { Company } from '../home/master/company/company';
import { Router } from '../../../node_modules/@angular/router';

@Component({
  selector: 'app-client-reg',
  templateUrl: './client-reg.component.html',
  styleUrls: ['./client-reg.component.scss'],
  providers: [MasterService]
})
export class ClientRegComponent implements OnInit {
  lic: any;
  modalTitle: string;
  countryList: Country[];
  clientForm: FormGroup;
  clientList: ClientReg[];
  companyList: Company[];
  selectedPet: string;
  UserForm: FormGroup;
  sampleText: NguModal;

  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService,
    private router: Router,
    private auth: AuthService
  ) {}

  ngOnInit() {
    // this.getCompany();
    this.getCountry();
    this.createForm();
    this.createuser();
    // this.selectedPet = '1';
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };
    this.modalTitle = 'User Company Registration';
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
  createForm() {
    this.clientForm = this.fb.group({
      ClientId: '',
      ClientCode: '',
      ClientName: ['', Validators.required],
      TaxNo: '',
      GSTNo: '',
      ContactPerson: '',
      Designation: '',
      HandPhoneNo: '',
      TelePhoneNo: '',
      EmailId: ['', Validators.required],
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
      License: ['', Validators.required],
      Cost: ['', Validators.required],
      Remark: ''
    });
    this.clientForm.get('NoofUser').valueChanges.subscribe(res => {
      if (res === 10) {
        if (this.clientForm.value.License === 1) {
          this.lic = 10000;
        } else if (this.clientForm.value.License === 2) {
          this.lic = 30000;
        }
      } else if (res === 25) {
        if (this.clientForm.value.License === 1) {
          this.lic = 20000;
        } else if (this.clientForm.value.License === 2) {
          this.lic = 35000;
        }
      } else if (res === 50) {
        if (this.clientForm.value.License === 1) {
          this.lic = 25000;
        } else if (this.clientForm.value.License === 2) {
          this.lic = 40000;
        }
      } else if (res === 100) {
        if (this.clientForm.value.License === 1) {
          this.lic = 35000;
        } else if (this.clientForm.value.License === 2) {
          this.lic = 55000;
        }
      }
    });

    this.clientForm.patchValue({
      Cost: this.lic
    });
  }
  logOut() {
    this.router.navigate(['/']);
  }
  clientSubmit() {
    console.log(this.clientForm.value);

    this.UserForm.reset();
    this.modal.open(this.sampleText.id);
  }
  createuser() {
    this.UserForm = this.fb.group({
      ClientId: '',
      UserName: ['', Validators.required],
      Password: ['', Validators.required]
    });
  }
  UserSubmit() {
    console.log(this.UserForm.value);
    // if (this.UserForm.value.UserName === '') {
    //   this.alert.open({
    //     heading: 'Update Failed',
    //     msg: 'Enter UserName',
    //     type: 'danger',
    //     duration: 5000
    //   });
    // }
    // if (this.UserForm.value.Password === '') {
    //   this.alert.open({
    //     heading: 'Update Failed',
    //     msg: 'Enter Password',
    //     type: 'danger',
    //     duration: 5000
    //   });
    // }
  }
  closeModal() {
    this.modal.close(this.sampleText.id);
  }
}
