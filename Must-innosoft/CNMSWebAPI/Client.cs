//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CNMSDataAccess
{
    using System;
    using System.Collections.Generic;
    
    public partial class Client
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Client()
        {
            this.DatabaseDetails = new HashSet<DatabaseDetail>();
            this.UserRoleMenus = new HashSet<UserRoleMenu>();
            this.SupplierMasters = new HashSet<SupplierMaster>();
            this.UserDetails = new HashSet<UserDetail>();
            this.HolidayMasters = new HashSet<HolidayMaster>();
        }
    
        public long ClientId { get; set; }
        public int CompanyId { get; set; }
        public string ClientCode { get; set; }
        public string ClientName { get; set; }
        public string TaxNo { get; set; }
        public string GSTNo { get; set; }
        public string ContactPerson { get; set; }
        public string Designation { get; set; }
        public string HandPhoneNo { get; set; }
        public string TelePhoneNo { get; set; }
        public string EmailId { get; set; }
        public string Website { get; set; }
        public string UintNo { get; set; }
        public string Building { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public Nullable<int> StateCode { get; set; }
        public Nullable<long> Pincode { get; set; }
        public int CountryId { get; set; }
        public Nullable<int> NoofUser { get; set; }
        public string Remark { get; set; }
        public Nullable<System.DateTime> ExprieDate { get; set; }
        public Nullable<System.DateTime> Modfied_Date { get; set; }
        public Nullable<int> Status { get; set; }
    
        public virtual Company Company { get; set; }
        public virtual Country Country { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DatabaseDetail> DatabaseDetails { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<UserRoleMenu> UserRoleMenus { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SupplierMaster> SupplierMasters { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<UserDetail> UserDetails { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<HolidayMaster> HolidayMasters { get; set; }
    }
}
