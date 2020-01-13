import { NguAlertService } from '@ngu/alert';
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from './../shared/core';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit, AfterViewInit {
  userRole: number;
  loginForm: FormGroup;
  imgSrc: string;
  procs: number;
  userAlert: string;
  loginerr = false;
  constructor(
    private fb: FormBuilder,
    private router: Router,
    private auth: AuthService,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    // tslint:disable-next-line:no-unused-expression
    this.auth.isLoggedIn && this.router.navigate(['/home/master']);
    console.log(this.auth.isLoggedIn);

    this.initForm();
    this.imgSrc = 'assets/pro.jpg';
    this.userRole = this.auth.userRole;
  }

  ngAfterViewInit() {}

  loginIn(user: any) {
    this.procs = 1;
    this.loginerr = false;
    this.auth.login(user).then((res: any) => {
      if (res.status) {
        console.log(this.userRole);
        // if (this.userRole === 8) {
        //   this.router.navigate(['/home/client']);
        // } else {
        this.router.navigate(['/home']);
        this.alert.open({
          heading: 'Login Successfully',
          msg: res.message
        });
        // }
      } else {
        this.userAlert = res.message;
        this.procs = 0;
        this.loginerr = true;
      }
    });
  }

  private initForm() {
    this.procs = 0;
    this.loginForm = this.fb.group({
      ClientCode: [
        '',
        Validators.compose([Validators.required, Validators.pattern(/^\d*$/)])
      ],
      Username: ['', Validators.required],
      Password: ['', Validators.required]
    });
  }
  goToPage() {
    this.router.navigate(['client-reg']);
  }
  goToPageFP() {
    this.router.navigate(['forgetpass']);
  }
}
