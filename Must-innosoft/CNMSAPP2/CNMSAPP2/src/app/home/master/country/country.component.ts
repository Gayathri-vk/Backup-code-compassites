import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { MasterService } from '../master.service';
import { Country } from './country';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';

@Component({
  selector: 'app-country',
  templateUrl: './country.component.html',
  styleUrls: ['./country.component.scss']
})
export class CountryComponent implements OnInit {

  modalTitle: string;
  isAdd: boolean;
  countryForm: FormGroup;
  countryList: Country[];
  sampleText: NguModal;

  displayedColumns = [  'Country_Name', 'Country_Code', 'Country_TimeZone', 'Country_Currency', 'Action'];
  dataSource = new MatTableDataSource(this.countryList);
  constructor(private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService) { }

  ngOnInit() {
    this.getCountry();

    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }
  private getCountry() {
    this.ms.getCountry().subscribe(res => {
      console.log(res);
      this.countryList = res;
      this.dataSource.data = this.countryList;
    });
  }

  createForm() {
    this.countryForm = this.fb.group({


      CountryId: '',
      Country_Name: ['', Validators.required],
      Country_Code: '',
      Country_TimeZone: '',
      Country_Currency: '',
      Status: ['', Validators.required],


    });
  }

  countrySubmit() {
    console.log(this.countryForm.value);
    if (this.isAdd) {
      this.ms.addCountry(this.countryForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getCountry();
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
      this.ms.updateCountry(this.countryForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getCountry();
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

editCountry(row) {
  this.modalTitle = 'Edit Country';
  this.isAdd = false;
  console.log(row);

  this.countryForm.patchValue({
    CountryId: row.CountryId,
Country_Name: row.Country_Name,
Country_Code: row.Country_Code,
Country_TimeZone: row.Country_TimeZone,
Country_Currency: row.Country_Currency,


    Status: row.Status

  });
  this.modal.open(this.sampleText.id);
  // this.companyForm.reset();
}


addCountry() {
  this.modalTitle = 'Add Country';
  this.isAdd = true;
  this.getCountry();
  this.countryForm.reset();
  this.modal.open(this.sampleText.id);
}

applyFilter(filterValue: string) {
  filterValue = filterValue.trim(); // Remove whitespace
  filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
  this.dataSource.filter = filterValue;
}

}
