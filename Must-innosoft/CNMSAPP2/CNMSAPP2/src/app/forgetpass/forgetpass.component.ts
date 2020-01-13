import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { AuthService } from '../shared/core';
import { Router } from '../../../node_modules/@angular/router';
import { NguModal } from '@ngu/modal';
import { AppService } from '../app.service';

@Component({
  selector: 'app-forgetpass',
  templateUrl: './forgetpass.component.html',
  styleUrls: ['./forgetpass.component.scss']
})
export class ForgetpassComponent implements OnInit {
  modalTitle: string;
  forpassForm: FormGroup;
  sampleText: NguModal;
  constructor(
    private fb: FormBuilder,
    private alert: NguAlertService,
    private router: Router,
    private ms: AppService
  ) {}

  ngOnInit() {
    this.createForm();
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };
    this.modalTitle = 'Forget Password';
  }
  createForm() {
    this.forpassForm = this.fb.group({
      ClientCode: ['', Validators.required],
      Email: ['', Validators.required]
    });
  }
  logOut() {
    this.router.navigate(['/']);
  }
  forpassSubmit() {
    console.log(this.forpassForm.value);

    this.ms.addUserPass(this.forpassForm.value).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Password Reset Successfully',
          msg: res.message
        });
        this.logOut();
      } else {
        this.alert.open({
          heading: 'Saving Failed',
          msg: res.message,
          type: 'danger',
          duration: 5000
        });
      }

      this.clear();
    });
  }
  clear() {
    this.forpassForm.patchValue({
      ClientCode: '',
      Email: ''
    });
  }
}
