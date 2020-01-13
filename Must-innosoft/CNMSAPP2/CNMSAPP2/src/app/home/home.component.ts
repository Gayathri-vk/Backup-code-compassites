import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../shared/core';
import { routerTransition } from '../shared/core';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
  animations: [routerTransition]
})
export class HomeComponent implements OnInit {
  expMsg: string;
  constructor(private auth: AuthService, private router: Router) {}

  ngOnInit() {
    this.expMsg = this.auth.ExpireMsg;
  }

  logout() {
    this.auth.logout();
    this.router.navigate(['']);
  }

  getState(outlet) {
    return outlet.activatedRouteData.state;
  }
}
