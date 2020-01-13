export interface Country {

  CountryId: number;
  Country_Name: string;
  Country_Code: string;
  Country_TimeZone?: any;
  Country_Currency?: any;
  Status: number;


}

export interface CountryRes {
  status: boolean;
  message: string;
}
