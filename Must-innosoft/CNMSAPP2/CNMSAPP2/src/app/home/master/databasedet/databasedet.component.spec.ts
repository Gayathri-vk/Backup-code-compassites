import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DatabasedetComponent } from './databasedet.component';

describe('DatabasedetComponent', () => {
  let component: DatabasedetComponent;
  let fixture: ComponentFixture<DatabasedetComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DatabasedetComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DatabasedetComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
