import {
  Component,
  OnInit,
  ElementRef,
  Renderer2,
  ViewChildren,
  QueryList,
  ContentChildren,
  AfterViewInit
} from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from './../shared/core';
import { RoleData, Nav } from './navigation';
import { AppService } from '../app.service';
import { MenuDetailsRes } from '../home/master/usermenu/usermenu';

@Component({
  selector: 'app-navigation',
  templateUrl: './navigation.component.html',
  styleUrls: ['./navigation.component.scss'],
  animations: []
})
export class NavigationComponent implements OnInit {
  naviList: MenuDetailsRes;
  userrole: any;
  role: any;
  @ViewChildren('openNav') openNav: QueryList<ElementRef>;

  @ViewChildren('openNavClick') openNavClick: QueryList<ElementRef>;

  public roleLists: any;
  public roleList: any;
  public roleListddd: any;
  private mobilescreen: number;
  constructor(
    private el: ElementRef,
    private renderer: Renderer2,
    private auth: AuthService,
    private router: Router,
    private as: AppService
  ) {}

  ngOnInit() {
    // this.naviList = RoleData;
    // this.roleList = this.roleList1.admin;
    // console.log(this.roleList);
    this.roleLists = sessionStorage.getItem('role');
    this.mobilescreen = window.innerWidth;
    // this.role = this.auth.userRole;
    // this.renderer.listen(this.openNavClick, 'click', (event) => {
    //   console.log(event);
    // });

    this.userrole = this.auth.userRole;
    this.getMenus();
    // this.naviList = this.auth.userMenu;
    // console.log(this.auth.userMenu);
  }

  getMenus() {
    this.as.getMenus(this.userrole).subscribe(res => {
      console.log(res);
      this.naviList = res;
    });
  }

  public toggleMenu(btn: number) {
    const cond = document.querySelector('body').classList;
    if (this.mobilescreen < 1024 || btn === 0) {
      if (cond.contains('navopen')) {
        this.renderer.removeClass(document.body, 'navopen');
        this.renderer.addClass(document.body, 'navHide');
      } else {
        this.renderer.removeClass(document.body, 'navHide');
        this.renderer.addClass(document.body, 'navopen');
      }
    }
  }

  logOut() {
    this.auth.logout();
    this.router.navigate(['/']);
  }

  openSubMenu(id) {
    // console.log(event.target.parentNode.parentNode.classList);
    const cond = document.querySelector('body').classList;
    this.openNav.forEach((elem, index) => {
      this.renderer.removeClass(elem.nativeElement, 'active');
      // tslint:disable-next-line:no-unused-expression
      index === id && this.renderer.addClass(elem.nativeElement, 'active');
    });
    if (this.mobilescreen > 767 && cond.contains('navHide')) {
      this.renderer.removeClass(document.body, 'navHide');
      this.renderer.addClass(document.body, 'navopen');
    }
  }
}
