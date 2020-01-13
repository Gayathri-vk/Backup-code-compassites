/**
 * @param 1 = Admin
 * @param 2 = Company
 * @param 3 = Client
 */

export const RoleData: Nav[] = [
  {
    main: 'Master',
    role: [1, 2],
    icon: 'fa-sitemap',
    route: 'master',
    list: [
      {
        name: 'Dashboard',
        icon: 'fa-home',
        route: 'master/dashboard',
        role: [1, 2]
      },
      {
        name: 'Admin Company',
        icon: 'fa-home',
        route: 'master/company',
        role: [1]
      },
      {
        name: 'Country',
        icon: 'fa-clock-o',
        route: 'master/country',
        role: [1]
      },
      {
        name: 'Client Company',
        icon: 'fa-clock-o',
        route: 'master/client',
        role: [1, 2]
      },
      {
        name: 'User Role Menu',
        icon: 'fa-clock-o',
        route: 'master/usermenu',
        role: [1, 2]
      },
      {
        name: 'User Details',
        icon: 'fa-clock-o',
        route: 'master/userdetails',
        role: [1, 2]
      }
    ]
  },
  {
    main: 'Projects',
    role: [1, 2, 3],
    icon: 'fa-sitemap',
    route: 'process',
    list: [
      {
        name: 'Location',
        icon: 'fa-home',
        route: 'process/location',
        role: [1, 2]
      },
      {
        name: 'Company',
        icon: 'fa-home',
        route: 'master/company',
        role: [1]
      },
      {
        name: 'Country',
        icon: 'fa-clock-o',
        route: 'master/country',
        role: [1]
      },
      {
        name: 'Client',
        icon: 'fa-clock-o',
        route: 'master/client',
        role: [1, 2, 3]
      },
      {
        name: 'UserDetails',
        icon: 'fa-clock-o',
        route: 'master/userdetails',
        role: [1, 2, 3]
      }
    ]
  }
];

export interface Nav {
  main: string;
  role: number[];
  icon: string;
  route: string;
  list: NavList[];
}

export interface NavList {
  name: string;
  icon: string;
  route: string;
  role: number[];
}

export interface UserMenuDetailsRes {
  RouteName: string;
  Formname: string;
}
