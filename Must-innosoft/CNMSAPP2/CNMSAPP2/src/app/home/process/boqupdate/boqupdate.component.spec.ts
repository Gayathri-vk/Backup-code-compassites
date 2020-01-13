import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqupdateComponent } from './boqupdate.component';

describe('BoqupdateComponent', () => {
  let component: BoqupdateComponent;
  let fixture: ComponentFixture<BoqupdateComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqupdateComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqupdateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
