import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import { Company, CompanyRes } from './company/company';
import { Client, ClientRes } from './client/client';
import { Country, CountryRes } from './country/country';
import { DatabaseDetails, DatabaseRes } from './databasedet/databasedet';
import {
  UserDetailsRes,
  UserDetails,
  UserRoleRes
} from './userdetails/userdetails';
import {
  UserRoleMenu,
  UserRoleMenuRes,
  MenuDetailsRes
} from './usermenu/usermenu';
import { Supplier, SupplierRes } from './supplier/supplier';
import { HolidayMasterRes, HolidayMaster } from './holidayentry/holidayentry';

@Injectable()
export class MasterService {
  constructor(private http: HttpClient) {}

  getCompany() {
    return this.http.get<Company[]>('Company');
  }

  addCompany(body) {
    return this.http.post<CompanyRes>('Company', body);
  }

  updateCompany(body) {
    return this.http.post<CompanyRes>(`Company`, body);
  }

  // -------------------------------- Client -------------------------------------

  getClient() {
    return this.http.get<Client[]>('Client');
  }

  getClientLite(id) {
    return this.http.get<Client[]>(`Client/${id}`);
  }

  addClient(body) {
    return this.http.post<ClientRes>('Client', body);
  }

  updateClient(body) {
    return this.http.post<ClientRes>(`Client`, body);
  }

  // -------------------------------- Country -------------------------------------

  getCountry() {
    return this.http.get<Country[]>('Country');
  }

  addCountry(body) {
    return this.http.post<CountryRes>('Country', body);
  }

  updateCountry(body) {
    return this.http.post<CountryRes>(`Country`, body);
  }

  getDatabase() {
    return this.http.get<DatabaseDetails[]>('DatabaseDetails');
  }

  addDatabase(body) {
    return this.http.post<DatabaseRes>('DatabaseDetails', body);
  }

  updateDatabase(body) {
    return this.http.post<DatabaseRes>(`DatabaseDetails`, body);
  }

  // -------------------------------- User -------------------------------------

  getUser() {
    return this.http.get<UserDetails[]>('UserDetails');
  }

  addUser(body) {
    return this.http.post<UserDetailsRes>('UserDetails', body);
  }

  updateUser(body) {
    return this.http.post<UserDetailsRes>(`UserDetails`, body);
  }

  getUserRole(id) {
    return this.http.get<UserRoleRes>(`UserDetails/${id}`);
  }

  // -------------------------------- User Role Menu -------------------------------------
  getUsermenu() {
    return this.http.get<UserRoleMenu[]>('Menu');
  }

  addUsermenu(body) {
    return this.http.post<UserRoleMenuRes>('Menu', body);
  }

  updateUsermenu(body) {
    return this.http.post<UserRoleMenuRes>(`Menu`, body);
  }

  getMenu(id) {
    return this.http.get<MenuDetailsRes>(`Menu/${id}`);
  }
  delItem(id, val) {
    return this.http.get<UserRoleMenuRes>(`Menu/?id=${id}&val=${val}`);
  }
  // -------------------------------- Supplier -------------------------------------
  getSupplier() {
    return this.http.get<[Supplier]>('Supplier');
  }
  addSupplier(body) {
    return this.http.post<SupplierRes>('Supplier', body);
  }
  updateSupplier(body) {
    return this.http.post<SupplierRes>('Supplier', body);
  }
  getSupplierDet(id) {
    return this.http.get<Supplier>(`Supplier/${id}`);
  }
  // -------------------------------- Holiday -------------------------------------
  getHoliday() {
    return this.http.get<[HolidayMaster]>('Holiday');
  }
  addHoliday(body) {
    return this.http.post<HolidayMasterRes>('Holiday', body);
  }
  updateHoliday(body) {
    return this.http.post<HolidayMasterRes>('Holiday', body);
  }
}
