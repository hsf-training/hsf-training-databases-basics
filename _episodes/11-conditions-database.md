
# Conditions Database Example Using SQLAlchemy

This lesson demonstrates how to create a simple Conditions Database using SQLAlchemy in Python. 
We will define three tables: `GlobalTag`, `PayloadType`, and `PayloadIOV`, and establish relationships 
between them. We will then add example data and query the database to retrieve specific entries.

## Imports
First, we import the necessary modules from SQLAlchemy.

```python
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.orm import declarative_base, sessionmaker, relationship
## Define ORM Models
We define our ORM models: `GlobalTag`, `PayloadType`, and `PayloadIOV`, along with the necessary relationships.

from sqlalchemy.sql import func, and_
```
## Database Connection
Next, we define the MySQL database connection URL and create an SQLAlchemy engine, session, and declarative base.

```python
# Define the MySQL database connection URL
db_url = "mysql+pymysql://root:pass@localhost:3306/cdb"

# Create an SQLAlchemy engine
engine = create_engine(db_url)
Session = sessionmaker(bind=engine)
session = Session()
Base = declarative_base()
```
## Define Tables
We define all the tables in the database.

```python
class GlobalTag(Base):
    __tablename__ = "GlobalTag"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), unique=True, nullable=False)

    # Relationship to PayloadType
    payload_types = relationship("PayloadType", back_populates="global_tag")

class PayloadType(Base):
    __tablename__ = "PayloadType"
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(255), unique=True, nullable=False)
    global_tag_id = Column(Integer, ForeignKey('GlobalTag.id'))

    # Relationship to GlobalTag and PayloadIOV
    global_tag = relationship("GlobalTag", back_populates="payload_types")
    payload_iovs = relationship("PayloadIOV", back_populates="payload_type")

class PayloadIOV(Base):
    __tablename__ = "PayloadIOV"
    id = Column(Integer, primary_key=True, autoincrement=True)
    payload_url = Column(String(255), nullable=False)
    iov = Column(Integer, nullable=False)
    payload_type_id = Column(Integer, ForeignKey('PayloadType.id'))

    # Relationship to PayloadType
    payload_type = relationship("PayloadType", back_populates="payload_iovs")
```
## Create Tables
We create all the tables in the database.

```python
# Create all tables in the database
Base.metadata.drop_all(engine)
Base.metadata.create_all(engine)
```
## Adding Example Data
We add some example data to the database for `GlobalTag`, `PayloadType`, and `PayloadIOV`.

```python
# Adding example data
global_tag = GlobalTag(name="DetectorConfiguration")
session.add(global_tag)

daq_payload_type = PayloadType(name="DAQSettings", global_tag=global_tag)
dcs_payload_type = PayloadType(name="DCSSettings", global_tag=global_tag)

session.add(daq_payload_type)
session.add(dcs_payload_type)

daq_payload_iovs = [
    PayloadIOV(payload_url="http://example.com/daq1", iov=1, payload_type=daq_payload_type),
    PayloadIOV(payload_url="http://example.com/daq2", iov=2, payload_type=daq_payload_type),
    PayloadIOV(payload_url="http://example.com/daq3", iov=3, payload_type=daq_payload_type)
]

dcs_payload_iovs = [
    PayloadIOV(payload_url="http://example.com/dcs1", iov=1, payload_type=dcs_payload_type),
    PayloadIOV(payload_url="http://example.com/dcs2", iov=2, payload_type=dcs_payload_type),
    PayloadIOV(payload_url="http://example.com/dcs3", iov=3, payload_type=dcs_payload_type)
]

session.add_all(daq_payload_iovs)
session.add_all(dcs_payload_iovs)
session.commit()
```
## Query the Database
Finally, we query the database to get the latest `PayloadIOV` entries for each `PayloadType` for a specific `GlobalTag` and IOV.

```python
# Query to get the last PayloadIOV entries for each PayloadType for a specific GlobalTag and IOV
requested_iov = 2
requested_gt = "DetectorConfiguration"

# Subquery to find the maximum IOV for each PayloadType
subquery = (session.query(
                PayloadIOV.payload_type_id,
                func.max(PayloadIOV.iov).label('max_iov')
            )
            .join(PayloadType, PayloadType.id == PayloadIOV.payload_type_id)
            .join(GlobalTag, GlobalTag.id == PayloadType.global_tag_id)
            .filter(GlobalTag.name == requested_gt, PayloadIOV.iov <= requested_iov)
            .group_by(PayloadIOV.payload_type_id)
            .subquery())

# Main query to get the latest PayloadIOV for each PayloadType
query = (session.query(
            GlobalTag.name.label('global_tag_name'),
            PayloadType.name.label('payload_type_name'),
            PayloadIOV.payload_url,
            subquery.c.max_iov
         )
         .join(PayloadType, GlobalTag.id == PayloadType.global_tag_id)
         .join(subquery, subquery.c.payload_type_id == PayloadType.id)
         .join(PayloadIOV, and_(
             PayloadType.id == PayloadIOV.payload_type_id,
             subquery.c.max_iov == PayloadIOV.iov
         ))
         .filter(GlobalTag.name == requested_gt)
         .order_by(PayloadType.name)
        ).all()

for global_tag_name, payload_type_name, payload_url, max_iov in query:
    print(f"GlobalTag: {global_tag_name}, PayloadType: {payload_type_name}, PayloadIOV URL: {payload_url}, IOV: {max_iov}")
```

    GlobalTag: DetectorConfiguration, PayloadType: DAQSettings, PayloadIOV URL: http://example.com/daq2, IOV: 2
    GlobalTag: DetectorConfiguration, PayloadType: DCSSettings, PayloadIOV URL: http://example.com/dcs2, IOV: 2
