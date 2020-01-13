import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SubSubItemComponent } from './sub-sub-item.component';

describe('SubSubItemComponent', () => {
  let component: SubSubItemComponent;
  let fixture: ComponentFixture<SubSubItemComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SubSubItemComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SubSubItemComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
