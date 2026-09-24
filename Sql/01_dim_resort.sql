
USE ski_analytics;
;

-- 1. Resort Dimension Table
CREATE TABLE dim_resort (
    resort_id VARCHAR(50) PRIMARY KEY,
    resort_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    domain_name VARCHAR(100),
    total_pistes_km INT NOT NULL,
    base_elevation_m INT NOT NULL,
    summit_elevation_m INT NOT NULL,
    station_elevation_m INT NOT NULL,
    mid_elevation_m INT GENERATED ALWAYS AS ((base_elevation_m + summit_elevation_m) / 2) STORED
);

INSERT INTO dim_resort 
(resort_id, resort_name, country, domain_name, total_pistes_km, base_elevation_m, summit_elevation_m, station_elevation_m) 
VALUES
('val_thorens', 'Val Thorens', 'France', 'Les 3 Vallées', 600, 2300, 3230, 2300),
('courchevel', 'Courchevel', 'France', 'Les 3 Vallées', 600, 1300, 2738, 1850),
('meribel', 'Méribel', 'France', 'Les 3 Vallées', 600, 1450, 2952, 1700),
('val_disere', 'Val d''Isère', 'France', 'Tignes-Val d''Isère', 300, 1850, 3456, 1850),
('tignes', 'Tignes', 'France', 'Tignes-Val d''Isère', 300, 1550, 3456, 2100),
('avoriaz', 'Avoriaz', 'France', 'Portes du Soleil', 650, 1800, 2460, 1800),
('chamonix', 'Chamonix (Mont-Blanc)', 'France', 'Chamonix Valley', 150, 1035, 3842, 1035),
('les_arcs', 'Les Arcs', 'France', 'Paradiski', 425, 1200, 3226, 1800),
('la_plagne', 'La Plagne', 'France', 'Paradiski', 425, 1250, 3250, 1970),
('alpe_dhuez', 'Alpe d''Huez', 'France', 'Alpe d''Huez Grand Domaine', 250, 1860, 3330, 1860),
('les_deux_alpes', 'Les Deux Alpes', 'France', 'Les 2 Alpes', 200, 1650, 3560, 1650),
('st_anton', 'St. Anton am Arlberg', 'Austria', 'Ski Arlberg', 305, 1304, 2811, 1304),
('lech_zurs', 'Lech-Zürs', 'Austria', 'Ski Arlberg', 305, 1450, 2450, 1450),
('kitzbuhel', 'Kitzbühel', 'Austria', 'KitzSki', 233, 800, 2000, 800),
('saalbach', 'Saalbach-Hinterglemm', 'Austria', 'Skicircus', 270, 1003, 2096, 1003),
('ischgl', 'Ischgl', 'Austria', 'Silvretta Arena', 239, 1377, 2872, 1377),
('solden', 'Sölden', 'Austria', 'Ötztal', 144, 1350, 3340, 1350),
('mayrhofen', 'Mayrhofen', 'Austria', 'Zillertal', 142, 630, 2500, 630),
('zell_am_see', 'Zell am See - Kaprun', 'Austria', 'Ski Alpin Card', 408, 757, 3029, 757),
('zermatt', 'Zermatt', 'Switzerland', 'Matterhorn Ski Paradise', 360, 1620, 3883, 1620),
('verbier', 'Verbier', 'Switzerland', '4 Vallées', 412, 1500, 3330, 1500),
('st_moritz', 'St. Moritz', 'Switzerland', 'Engadin St. Moritz', 350, 1822, 3303, 1822),
('laax', 'Laax (Flims Laax Falera)', 'Switzerland', 'LAAX', 224, 1100, 3018, 1100),
('davos_klosters', 'Davos-Klosters', 'Switzerland', 'Davos Klosters', 293, 1560, 2844, 1560),
('saas_fee', 'Saas-Fee', 'Switzerland', 'Saas-Fee Glacier', 150, 1800, 3600, 1800),
('cortina', 'Cortina d''Ampezzo', 'Italy', 'Dolomiti Superski', 120, 1224, 2828, 1224),
('val_gardena', 'Val Gardena', 'Italy', 'Dolomiti Superski', 181, 1236, 2518, 1236),
('cervinia', 'Cervinia', 'Italy', 'Matterhorn Ski Paradise', 360, 2050, 3480, 2050),
('livigno', 'Livigno', 'Italy', 'Livigno', 115, 1816, 2900, 1816),
('sestriere', 'Sestriere', 'Italy', 'Via Lattea', 400, 2035, 2823, 2035);
